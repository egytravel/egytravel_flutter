import 'package:egytravel_app/core/routes/app_routes.dart';
import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/feature/ai_trip_planner/logic/controller/ai_trip_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class TripResultScreen extends GetView<TripController> {
  const TripResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1628),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CustomBackButton(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Trip Itinerary',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Obx(() => Text(
              controller.selectedCity.value.toLowerCase(),
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
            )),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.aiChat),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.pink],
              ),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white),
          ),
        ),
      ),
      body: controller.obx(
        (trip) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTripSummaryBar(),
                    const SizedBox(height: 25),
                    _buildDaySelector(trip!.data.days),
                    const SizedBox(height: 25),
                    // ── Map Card ──────────────────────────────────────────────
                    Obx(() => _buildMapCard(
                          trip.data.days[controller.selectedDayIndex.value].activities,
                          trip.data.hotel,
                        )),
                    const SizedBox(height: 20),
                    _buildFlightDetails(),
                    const SizedBox(height: 20),
                    if (trip.data.hotel != null) ...[
                      _buildAccommodation(trip.data.hotel!),
                      const SizedBox(height: 25),
                    ],
                    const Text(
                      'Daily Activities',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Obx(() => _buildDailyActivities(
                          trip.data.days[controller.selectedDayIndex.value].activities,
                          controller.selectedDayIndex.value,
                        )),
                    const SizedBox(height: 25),
                    Obx(() => _buildPlacesUsed(
                          trip.data.days[controller.selectedDayIndex.value].activities,
                        )),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            // ── Save Trip Bottom Bar ─────────────────────────────────────
            _buildSaveTripBar(),
          ],
        ),
        onLoading: const Center(child: CircularProgressIndicator(color: AppColor.primary)),
        onError: (error) => _buildErrorState(error),
      ),
    );
  }

  // ── Map Card ────────────────────────────────────────────────────────────────

  Future<void> _openGoogleMaps(double lat, double lon) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Error',
          'Could not open Google Maps',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open map: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Widget _buildMapCard(List activities, dynamic hotel) {
    // Collect all markers from activities with lat/lon
    final Set<Marker> markers = {};
    final List<LatLng> points = [];

    // Add hotel marker if available
    if (hotel != null && hotel.lat != 0.0 && hotel.lon != 0.0) {
      final hotelPoint = LatLng(hotel.lat, hotel.lon);
      points.add(hotelPoint);
      markers.add(Marker(
        markerId: const MarkerId('hotel'),
        position: hotelPoint,
        infoWindow: InfoWindow(title: hotel.name, snippet: 'Hotel'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        onTap: () => _openGoogleMaps(hotel.lat, hotel.lon),
      ));
    }

    // Add activity markers
    for (int i = 0; i < activities.length; i++) {
      final activity = activities[i];
      if (activity.lat != null && activity.lon != null && activity.lat != 0.0 && activity.lon != 0.0) {
        final point = LatLng(activity.lat!, activity.lon!);
        points.add(point);
        markers.add(Marker(
          markerId: MarkerId('activity_$i'),
          position: point,
          infoWindow: InfoWindow(title: activity.title, snippet: activity.time),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
          onTap: () => _openGoogleMaps(activity.lat!, activity.lon!),
        ));
      }
    }

    // Determine map center and zoom
    LatLng center;
    double zoom;
    if (points.isNotEmpty) {
      double sumLat = 0, sumLon = 0;
      for (var p in points) {
        sumLat += p.latitude;
        sumLon += p.longitude;
      }
      center = LatLng(sumLat / points.length, sumLon / points.length);
      zoom = points.length == 1 ? 14 : 12;
    } else {
      // Default Egypt center
      center = const LatLng(26.8206, 30.8025);
      zoom = 5;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.map_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Places on Map',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
            if (points.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${points.length} ${points.length == 1 ? 'place' : 'places'}',
                  style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: center,
                    zoom: zoom,
                  ),
                  markers: markers,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: true,
                  mapType: MapType.normal,
                  liteModeEnabled: false,
                ),
              ),
              if (points.isNotEmpty)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _openGoogleMaps(center.latitude, center.longitude),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D1B2A).withOpacity(0.85),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.orange.withOpacity(0.6), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.directions_rounded, color: Colors.orange, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Open in Maps',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (points.isNotEmpty) ...[
          const SizedBox(height: 12),
          // Place chips with locations
          SizedBox(
            height: 55,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: markers.length,
              itemBuilder: (context, index) {
                final marker = markers.elementAt(index);
                final isHotel = marker.markerId.value == 'hotel';
                return GestureDetector(
                  onTap: () => _openGoogleMaps(marker.position.latitude, marker.position.longitude),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF152232),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isHotel
                            ? Colors.blue.withOpacity(0.3)
                            : Colors.orange.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (isHotel ? Colors.blue : Colors.orange).withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (isHotel ? Colors.blue : Colors.orange).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isHotel ? Icons.hotel_rounded : Icons.location_on,
                            color: isHotel ? Colors.blue : Colors.orange,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              marker.infoWindow.title ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (marker.infoWindow.snippet != null && marker.infoWindow.snippet!.isNotEmpty)
                              Text(
                                marker.infoWindow.snippet!,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  // ── Save Trip Bottom Bar ──────────────────────────────────────────────────

  Widget _buildSaveTripBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2A).withOpacity(0.98),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.08)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Obx(() => Row(
          children: [
            // Trip info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${controller.selectedDays.value} Days Trip',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    controller.selectedCity.value,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Save button
            Expanded(
              child: ElevatedButton.icon(
                onPressed: controller.isSavingTrip.value
                    ? null
                    : () => controller.saveAiTrip(),
                icon: controller.isSavingTrip.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.bookmark_add_rounded, size: 20),
                label: Text(
                  controller.isSavingTrip.value ? 'Saving...' : 'Save Trip',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.orange.withOpacity(0.5),
                  disabledForegroundColor: Colors.white70,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 8,
                  shadowColor: Colors.orange.withOpacity(0.4),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildTripSummaryBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9D00), Color(0xFFFF5C00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(Icons.calendar_today, '${controller.selectedDays.value} Days', 'Duration'),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildSummaryItem(Icons.hotel_outlined, '${controller.selectedDays.value - 1} Nights', 'Accommodation'),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildSummaryItem(Icons.account_balance_wallet_outlined, controller.selectedBudget.value.capitalizeFirst!, 'Budget'),
        ],
      ),
    );
  }

  IconData _getIconForActivity(String title, String description) {
    final t = title.toLowerCase();
    final d = description.toLowerCase();
    
    if (t.contains('museum') || t.contains('history') || d.contains('ancient') || d.contains('landmark')) return Icons.museum_outlined;
    if (t.contains('restaurant') || t.contains('lunch') || t.contains('dinner') || t.contains('breakfast') || t.contains('food') || d.contains('cuisine')) return Icons.restaurant_outlined;
    if (t.contains('beach') || t.contains('water') || t.contains('sea') || d.contains('waves') || d.contains('swim')) return Icons.beach_access_outlined;
    if (t.contains('safari') || t.contains('adventure') || d.contains('jeep') || d.contains('mountain')) return Icons.directions_car_filled_outlined;
    if (t.contains('shop') || t.contains('market') || d.contains('mall') || d.contains('buy')) return Icons.shopping_bag_outlined;
    if (t.contains('relax') || t.contains('leisure') || t.contains('spa') || d.contains('chill')) return Icons.spa_outlined;
    if (t.contains('view') || t.contains('scenic') || d.contains('landscape') || d.contains('camera')) return Icons.camera_alt_outlined;
    
    return Icons.location_on_outlined;
  }

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }

  Widget _buildDaySelector(List days) {
    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          return Obx(() {
            final isSelected = controller.selectedDayIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectedDayIndex.value = index,
              child: Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.transparent : const Color(0xFF152232),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.orange : Colors.white10,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Day ${index + 1}',
                      style: TextStyle(
                        color: isSelected ? Colors.orange : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDayDate(index),
                      style: TextStyle(
                        color: isSelected ? Colors.orange.withOpacity(0.8) : Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  String _getDayDate(int index, {bool full = false}) {
    if (controller.startDate.value == null) return full ? "Wednesday, May ${13 + index}" : "May ${13 + index}";
    final date = controller.startDate.value!.add(Duration(days: index));
    return DateFormat(full ? 'EEEE, MMM d' : 'MMM d').format(date);
  }

  Widget _buildFlightDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.flight_takeoff, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text('Flight Details', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(Icons.edit_outlined, color: Colors.orange.withOpacity(0.8), size: 18),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF152232),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFlightLocation('From', 'Cairo International'),
                  const Icon(Icons.arrow_forward, color: Colors.orange, size: 18),
                  _buildFlightLocation('To', controller.selectedCity.value.toLowerCase(), alignEnd: true),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.access_time, color: Colors.white.withOpacity(0.5), size: 14),
                  const SizedBox(width: 6),
                  const Text('MS 101', style: TextStyle(color: Colors.white, fontSize: 13)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFlightLocation(String label, String city, {bool alignEnd = false}) {
    return Column(
      crossAxisAlignment: alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          city,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }


  Widget _buildAccommodation(dynamic hotel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.hotel_outlined, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            const Text('Accommodation', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const Spacer(),
            Icon(Icons.edit_outlined, color: Colors.orange.withOpacity(0.8), size: 18),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF152232),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(hotel.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 8),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (i) => Icon(
                      i < 4 ? Icons.star : Icons.star_half,
                      color: Colors.orange,
                      size: 14,
                    )),
                  ),
                  const SizedBox(width: 8),
                  Text('4.5 (120 reviews)', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlacesUsed(List activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Places Used in This Day', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        SizedBox(
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: activities.length,
            itemBuilder: (context, index) {
              final activity = activities[index];
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF152232),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    Icon(_getIconForActivity(activity.title, activity.description), color: Colors.orange, size: 14),
                    const SizedBox(width: 6),
                    Text(activity.title, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyActivities(List activities, int dayIndex) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_month, color: Colors.orange, size: 20),
            const SizedBox(width: 8),
            Text(
              'Day ${dayIndex + 1} - ${_getDayDate(dayIndex, full: true)}',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            final isLast = index == activities.length - 1;
            return _buildTimelineActivityItem(activity, isLast);
          },
        ),
      ],
    );
  }

  Widget _buildTimelineActivityItem(dynamic activity, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Part
          SizedBox(
            width: 70,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  activity.time,
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (!isLast)
                        Container(
                          width: 2,
                          color: Colors.white24,
                        ),
                      Container(
                        margin: const EdgeInsets.only(top: 2),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0A1628), width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.orange.withOpacity(0.5), blurRadius: 4),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content Part
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF152232),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getIconForActivity(activity.title, activity.description),
                      color: Colors.orange,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          activity.description,
                          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildErrorState(String? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 60),
          const SizedBox(height: 16),
          const Text('Something went wrong', style: TextStyle(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.generateTrip(),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}

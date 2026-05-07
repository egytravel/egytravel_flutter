import 'package:egytravel_app/core/widgets/custom_back_button.dart';
import 'package:egytravel_app/core/widgets/glassy_background.dart';
import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/logic/controller/trip_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripDetailsScreen extends StatelessWidget {
  final String tripId;
  const TripDetailsScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TripDetailsController(tripId));

    return GlassyBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const CustomBackButton(),
          title: Obx(
            () => Text(
              controller.trip.value?.title ?? 'Trip Details',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => controller.fetchTripDetails(),
              icon: const Icon(Icons.refresh, color: Colors.white),
            ),
            // Delete trip
            IconButton(
              onPressed: () => _showDeleteTripDialog(context, controller),
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ],
        ),
        // FAB: attach hotel to this trip
        floatingActionButton: Obx(
          () => FloatingActionButton.extended(
            onPressed: controller.isSaving.value
                ? null
                : () => _showAttachHotelDialog(context, controller),
            backgroundColor: Colors.orange,
            icon: controller.isSaving.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.hotel, color: Colors.white),
            label: const Text(
              'Attach Hotel',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.orange),
            );
          }

          if (controller.hasError.value) {
            return _buildErrorState(controller);
          }

          final trip = controller.trip.value;
          if (trip == null) {
            return const Center(
              child: Text(
                'Trip not found',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          final days = controller.days;

          return CustomScrollView(
            slivers: [
              // ── Trip Header Info ──────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (trip.description != null &&
                          trip.description!.isNotEmpty) ...[
                        Text(
                          trip.description!,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 14,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                      ],
                      _buildInfoChip(
                        Icons.location_on,
                        trip.destination ?? 'No destination',
                      ),
                      const SizedBox(height: 12),
                      _buildInfoChip(
                        Icons.calendar_today,
                        _formatDateRange(trip.startDate, trip.endDate),
                      ),
                      if (trip.budget != null && trip.budget! > 0) ...[
                        const SizedBox(height: 12),
                        _buildInfoChip(
                          Icons.attach_money,
                          'Budget: \$${trip.budget!.toStringAsFixed(0)}',
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // ── Hotel Section (from API) ───────────────────────────────────
              if (trip.hotel != null && trip.hotel!.isNotEmpty)
                SliverToBoxAdapter(child: _buildHotelSection(trip.hotel!)),

              if (controller.bookings.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildBookingsSection(controller.bookings),
                ),

              // ── Map Markers Section ───────────────────────────────────────
              SliverToBoxAdapter(
                child: Obx(() {
                  if (controller.isMapLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  }
                  if (controller.mapMarkers.isEmpty) return const SizedBox();
                  return _buildMapMarkersSection(controller.mapMarkers);
                }),
              ),

              // ── Days empty state ──────────────────────────────────────────
              if (days.isEmpty)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 48,
                          color: Colors.white24,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No itinerary days yet',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Itinerary Days ────────────────────────────────────────────
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final day = days[index];
                  return _buildDaySection(context, day, controller);
                }, childCount: days.length),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        }),
      ),
    );
  }

  // ── Hotel section ─────────────────────────────────────────────────────────

  Widget _buildHotelSection(Map<String, dynamic> hotel) {
    final name =
        hotel['name']?.toString() ?? hotel['hotelName']?.toString() ?? 'Hotel';
    final location =
        hotel['location']?.toString() ?? hotel['city']?.toString() ?? '';
    final price = hotel['pricePerNight'] ?? hotel['price'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.hotel,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Attached Hotel',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (location.isNotEmpty) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: Colors.white38,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            if (price != null) ...[
              const SizedBox(height: 4),
              Text(
                '\$$price / night',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBookingsSection(List<TripBookingModel> bookings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bookings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...bookings.map(_buildBookingCard),
        ],
      ),
    );
  }

  Widget _buildBookingCard(TripBookingModel booking) {
    final location = booking.displayLocation;
    final price = booking.displayPrice;
    final dateRange = _formatDateRange(
      booking.checkinDate,
      booking.checkoutDate,
    );
    final showDates =
        booking.checkinDate != null || booking.checkoutDate != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              booking.type.toLowerCase().contains('flight')
                  ? Icons.flight
                  : Icons.hotel,
              color: Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.displayTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (location.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    location,
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (showDates) ...[
                  const SizedBox(height: 4),
                  Text(
                    dateRange,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
                if (price.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    price,
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              booking.displayStatus,
              style: const TextStyle(
                color: Colors.greenAccent,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Map markers section ───────────────────────────────────────────────────

  Widget _buildMapMarkersSection(List<TripMapMarker> markers) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trip Locations',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...markers.map(
            (marker) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.place, color: Colors.orange, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marker.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (marker.description != null &&
                            marker.description!.isNotEmpty)
                          Text(
                            marker.description!,
                            style: const TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (marker.type != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        marker.type!,
                        style: const TextStyle(
                          color: Colors.orange,
                          fontSize: 11,
                        ),
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

  // ── Error state ───────────────────────────────────────────────────────────

  Widget _buildErrorState(TripDetailsController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.redAccent),
          const SizedBox(height: 16),
          Text(
            controller.errorMessage.value.isNotEmpty
                ? controller.errorMessage.value
                : 'Something went wrong',
            style: const TextStyle(color: Colors.white70, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.fetchTripDetails(),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Retry', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ── Info chip ─────────────────────────────────────────────────────────────

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.orange, size: 16),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Day section ───────────────────────────────────────────────────────────

  Widget _buildDaySection(
    BuildContext context,
    TripDayModel day,
    TripDetailsController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Day ${day.dayNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  day.title ??
                      day.notes ??
                      day.description ??
                      'Daily Itinerary',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Delete day button
              IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () => _showDeleteDayDialog(context, day, controller),
                tooltip: 'Delete day',
              ),
            ],
          ),
        ),
        if (day.activities != null && day.activities!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: day.activities!.length,
            itemBuilder: (context, idx) {
              final activity = day.activities![idx];
              return _buildActivityCard(activity);
            },
          ),
        if (day.activities == null || day.activities!.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Text(
              'No activities for this day',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.3),
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }

  // ── Activity card ─────────────────────────────────────────────────────────

  Widget _buildActivityCard(TripActivityModel activity) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activity.time != null && activity.time!.isNotEmpty) ...[
            Text(
              activity.time!,
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (activity.description != null &&
                    activity.description!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    activity.description!,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (activity.location != null &&
                    activity.location!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          activity.location!,
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (activity.cost != null && activity.cost! > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '\$${activity.cost!.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Dialogs ───────────────────────────────────────────────────────────────

  /// Dialog to attach a hotel booking to this trip via POST /bookings/hotel
  void _showAttachHotelDialog(
    BuildContext context,
    TripDetailsController controller,
  ) {
    final trip = controller.trip.value;
    final hotelIdCtrl = TextEditingController();
    final nameCtrl = TextEditingController();
    final locationCtrl = TextEditingController();
    final checkinCtrl = TextEditingController(text: trip?.startDate ?? '');
    final checkoutCtrl = TextEditingController(text: trip?.endDate ?? '');
    final guestsCtrl = TextEditingController(text: '1');
    final roomsCtrl = TextEditingController(text: '1');
    final totalPriceCtrl = TextEditingController();
    final currencyCtrl = TextEditingController(text: 'USD');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: const Text(
          'Attach Hotel to Trip',
          style: TextStyle(color: Colors.white),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(hotelIdCtrl, 'Hotel ID', Icons.badge_outlined),
              const SizedBox(height: 12),
              _dialogField(nameCtrl, 'Hotel Name', Icons.hotel),
              const SizedBox(height: 12),
              _dialogField(locationCtrl, 'Hotel Location', Icons.location_on),
              const SizedBox(height: 12),
              _dialogField(
                checkinCtrl,
                'Check-in Date',
                Icons.calendar_today,
                readOnly: true,
                onTap: () async {
                  final selected = await _pickDate(ctx, checkinCtrl.text);
                  if (selected != null) {
                    checkinCtrl.text = _formatApiDate(selected);
                  }
                },
              ),
              const SizedBox(height: 12),
              _dialogField(
                checkoutCtrl,
                'Check-out Date',
                Icons.calendar_today_outlined,
                readOnly: true,
                onTap: () async {
                  final selected = await _pickDate(ctx, checkoutCtrl.text);
                  if (selected != null) {
                    checkoutCtrl.text = _formatApiDate(selected);
                  }
                },
              ),
              const SizedBox(height: 12),
              _dialogField(
                guestsCtrl,
                'Guests',
                Icons.person_outline,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _dialogField(
                roomsCtrl,
                'Rooms',
                Icons.meeting_room_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _dialogField(
                totalPriceCtrl,
                'Total Price',
                Icons.attach_money,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const SizedBox(height: 12),
              _dialogField(currencyCtrl, 'Currency', Icons.currency_exchange),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final hotelId = hotelIdCtrl.text.trim();
              final hotelName = nameCtrl.text.trim();
              final checkinDate = checkinCtrl.text.trim();
              final checkoutDate = checkoutCtrl.text.trim();
              final totalPriceText = totalPriceCtrl.text.trim();
              final guests = int.tryParse(guestsCtrl.text.trim()) ?? 1;
              final rooms = int.tryParse(roomsCtrl.text.trim()) ?? 1;
              final totalPrice = double.tryParse(totalPriceText);
              final parsedCheckin = DateTime.tryParse(checkinDate);
              final parsedCheckout = DateTime.tryParse(checkoutDate);

              if (hotelId.isEmpty ||
                  hotelName.isEmpty ||
                  checkinDate.isEmpty ||
                  checkoutDate.isEmpty ||
                  totalPriceText.isEmpty) {
                showError(
                  'Please fill hotel id, hotel name, dates, and total price.',
                );
                return;
              }

              if (parsedCheckin == null || parsedCheckout == null) {
                showError('Please choose valid check-in and check-out dates.');
                return;
              }

              if (parsedCheckout.isBefore(parsedCheckin)) {
                showError('Check-out date must be after check-in date.');
                return;
              }

              if (guests < 1 || rooms < 1) {
                showError('Guests and rooms must be at least 1.');
                return;
              }

              if (totalPrice == null || totalPrice < 0) {
                showError('Please enter a valid total price.');
                return;
              }

              Navigator.pop(ctx);
              final hotelData = <String, dynamic>{
                'hotelId': hotelId,
                'hotelName': hotelName,
                'checkinDate': checkinDate,
                'checkoutDate': checkoutDate,
                'guests': guests,
                'rooms': rooms,
                'totalPrice': totalPrice,
                'currency': currencyCtrl.text.trim().isEmpty
                    ? 'USD'
                    : currencyCtrl.text.trim().toUpperCase(),
                if (locationCtrl.text.trim().isNotEmpty)
                  'hotelLocation': locationCtrl.text.trim(),
              };
              controller.attachHotel(hotelData);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Attach', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  /// Dialog to confirm deleting a day via DELETE /trips/{tripId}/days/{dayId}
  void _showDeleteDayDialog(
    BuildContext context,
    TripDayModel day,
    TripDetailsController controller,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: const Text('Delete Day', style: TextStyle(color: Colors.white)),
        content: Text(
          'Remove Day ${day.dayNumber} from this trip?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteDay(day.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  /// Dialog to confirm deleting the entire trip
  void _showDeleteTripDialog(
    BuildContext context,
    TripDetailsController controller,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F2E),
        title: const Text('Delete Trip', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this trip? This cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              controller.deleteTrip();
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  Widget _dialogField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.orange, size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.orange),
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context, String rawDate) async {
    final initialDate = DateTime.tryParse(rawDate) ?? DateTime.now();
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
  }

  String _formatApiDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String _formatDateRange(String? start, String? end) {
    if (start == null || end == null) return 'Dates not set';
    try {
      final s = DateTime.parse(start);
      final e = DateTime.parse(end);
      return '${DateFormat('MMM d').format(s)} - ${DateFormat('MMM d, yyyy').format(e)}';
    } catch (_) {
      return 'Invalid dates';
    }
  }
}
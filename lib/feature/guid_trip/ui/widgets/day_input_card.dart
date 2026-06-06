import 'package:egytravel_app/core/widgets/snack_bar.dart';
import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:egytravel_app/feature/guid_trip/logic/models/guide_day_model.dart';
import 'package:egytravel_app/feature/plan/data/model/trip_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class DayInputCard extends StatelessWidget {
  final GuideDayModel day;

  const DayInputCard({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GuideTripController>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                'Day ${day.dayNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Obx(() => IconButton(
                  icon: Icon(
                    day.isExpanded.value
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_right,
                    color: Colors.white,
                  ),
                  onPressed: () => day.isExpanded.toggle(),
                )),
          ],
        ),
        const SizedBox(height: 8),
        Obx(() => Visibility(
              visible: day.isExpanded.value,
              child: GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildTextField(
                      label: 'Title',
                      icon: Icons.place,
                      controller: day.placeController,
                      onChanged: (value) => day.place.value = value,
                    ),
                    
                    // ── Places List (Multiple Places) ─────────────────────────
                    Obx(() {
                      final customPlaces = day.locations
                          .where((loc) =>
                              (loc.type ?? '').toLowerCase() != 'hotel' &&
                              (loc.type ?? '').toLowerCase() != 'flight')
                          .toList();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const _SectionHeader(label: 'Places', icon: Icons.map_rounded),
                          const SizedBox(height: 10),
                          if (customPlaces.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'No places added yet',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.4),
                                  fontSize: 13,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                          else
                            ...customPlaces.map((loc) {
                              final originalIndex = day.locations.indexOf(loc);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: _PlaceCard(
                                  title: loc.name,
                                  subtitle: loc.address ?? '',
                                  onDelete: () {
                                    final tripId = controller.createdTripId;
                                    final dayId = day.id;
                                    if (tripId != null && dayId != null) {
                                      controller.removePlaceFromDay(
                                        tripId,
                                        dayId,
                                        originalIndex,
                                      );
                                    }
                                  },
                                ),
                              );
                            }),
                          const SizedBox(height: 10),
                          _AddPlaceButton(
                            onTap: () => _showPlaceSearchSheet(context),
                          ),
                        ],
                      );
                    }),
                    
                    // ── Accommodations (Hotels) ─────────────────────────────
                    Obx(() {
                      // 1. Get from bookings list
                      final hotelsFromBookings = day.bookings.where((b) => b.type.toLowerCase() == 'hotel').map((b) => {
                        'title': b.displayTitle,
                        'subtitle': b.displayLocation,
                        'price': b.displayPrice,
                      }).toList();

                      // 2. Get from locations list (if added via addPlaceToDay)
                      final hotelsFromLocations = controller.trip.value?.days
                          ?.firstWhereOrNull((d) => d.id == day.id || d.dayNumber == day.dayNumber)
                          ?.locations
                          ?.where((loc) => (loc.type ?? '').toLowerCase() == 'hotel')
                          .map((loc) => {
                            'title': loc.name,
                            'subtitle': 'Accommodation',
                            'price': '', // Locations might not have price in the same way
                          })
                          .toList() ?? [];

                      final allHotels = [...hotelsFromBookings, ...hotelsFromLocations];
                      
                      if (allHotels.isEmpty) return const SizedBox.shrink();
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const _SectionHeader(label: 'Accommodation', icon: Icons.hotel_rounded),
                          const SizedBox(height: 10),
                          ...allHotels.map((h) => _BookingCard(
                            title: h['title'] ?? 'Hotel',
                            subtitle: h['subtitle'] ?? '',
                            price: h['price'] ?? '',
                            icon: Icons.hotel_rounded,
                            color: Colors.orange,
                          )),
                        ],
                      );
                    }),

                    // ── Flights ─────────────────────────────────────────────
                    Obx(() {
                      // 1. Get from bookings list
                      final flightsFromBookings = day.bookings.where((b) => b.type.toLowerCase() == 'flight').map((b) => {
                        'title': b.displayTitle,
                        'subtitle': 'Flight to ${b.displayLocation}',
                        'price': b.displayPrice,
                      }).toList();

                      // 2. Get from locations list (if added via addPlaceToDay)
                      final flightsFromLocations = controller.trip.value?.days
                          ?.firstWhereOrNull((d) => d.id == day.id || d.dayNumber == day.dayNumber)
                          ?.locations
                          ?.where((loc) => (loc.type ?? '').toLowerCase() == 'flight')
                          .map((loc) => {
                            'title': loc.name,
                            'subtitle': loc.address ?? '',
                            'price': '',
                          })
                          .toList() ?? [];

                      final allFlights = [...flightsFromBookings, ...flightsFromLocations];

                      if (allFlights.isEmpty) return const SizedBox.shrink();
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const _SectionHeader(label: 'Flights', icon: Icons.flight_takeoff_rounded),
                          const SizedBox(height: 10),
                          ...allFlights.map((f) => _BookingCard(
                            title: f['title'] ?? 'Flight',
                            subtitle: f['subtitle'] ?? '',
                            price: f['price'] ?? '',
                            icon: Icons.flight_takeoff_rounded,
                            color: Colors.blueAccent,
                          )),
                        ],
                      );
                    }),

                    const SizedBox(height: 12),
                    _buildTextField(
                      label: 'Notes',
                      icon: Icons.note,
                      maxLines: 3,
                      controller: day.notesController,
                      onChanged: (value) => day.notes.value = value,
                    ),
                  ],
                ),
              ),
            )),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required Function(String) onChanged,
    int maxLines = 1,
    VoidCallback? onTap,
    bool readOnly = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: Colors.orange),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
      ),
    );
  }

  void _showPlaceSearchSheet(BuildContext context) {
    final controller = Get.find<GuideTripController>();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _PlaceSearchSheet(
        onPlaceSelected: (placeData) {
          final name = (placeData['name'] ?? placeData['title'] ?? '').toString();
          
          // Check if place is already added to this day (by matching name or non-zero lat/lng)
          final isDuplicate = day.locations.any((loc) =>
              loc.name.toLowerCase().trim() == name.toLowerCase().trim() ||
              (loc.lat != null && loc.lat != 0.0 && loc.lat == placeData['lat'] &&
               loc.lng != null && loc.lng != 0.0 && loc.lng == placeData['lng']));

          if (isDuplicate) {
            showError('This place is already added to this day!');
            return;
          }

          day.addressController.text = name;
          day.address.value = name;
          
          final tripId = controller.createdTripId;
          final dayId = day.id;
          
          if (tripId != null && dayId != null) {
            controller.addPlaceToDay(tripId, dayId, {
              'placeId': (placeData['id'] ?? placeData['_id'] ?? '').toString(),
              'name': name,
              'lat': placeData['lat'] ?? 0.0,
              'lng': placeData['lng'] ?? 0.0,
              'type': placeData['type'] ?? 'destination',
              'notes': day.notesController.text,
            });
          }
        },
      ),
    );
  }
}

// ── Live-search Bottom Sheet ──────────────────────────────────────────────────

class _PlaceSearchSheet extends StatefulWidget {
  final void Function(Map<String, dynamic> placeData) onPlaceSelected;

  const _PlaceSearchSheet({required this.onPlaceSelected});

  @override
  State<_PlaceSearchSheet> createState() => _PlaceSearchSheetState();
}

class _PlaceSearchSheetState extends State<_PlaceSearchSheet> {
  final TripRepo _repo = TripRepo();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  // Debounce timer
  DateTime? _lastSearch;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    if (query.trim().length < 2) {
      setState(() {
        _results = [];
        _hasSearched = false;
      });
      return;
    }

    // Debounce: wait 400 ms after user stops typing
    final searchTime = DateTime.now();
    _lastSearch = searchTime;
    await Future.delayed(const Duration(milliseconds: 400));
    if (_lastSearch != searchTime) return; // Another search was triggered

    setState(() => _isLoading = true);
    try {
      final raw = await _repo.searchPlaces(query.trim());
      if (!mounted) return;
      setState(() {
        _results = raw;
        _hasSearched = true;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _results = [];
        _hasSearched = true;
      });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _placeName(Map<String, dynamic> r) =>
      (r['name'] ?? r['title'] ?? r['placeName'] ?? '').toString().trim();

  String _placeLocation(Map<String, dynamic> r) =>
      (r['location'] ?? r['city'] ?? r['country'] ?? r['governorate'] ?? '')
          .toString()
          .trim();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) => Container(
        decoration: BoxDecoration(
          color: const Color(0xFF181F2A),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.15)),
          ),
        ),
        child: Column(
          children: [
            // ── Drag handle ───────────────────────────────────────────────
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),

            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Icon(Icons.place, color: Colors.orange, size: 20),
                  const SizedBox(width: 10),
                  const Text(
                    'Search for a place',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: Colors.white.withOpacity(0.5), size: 20),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Search box ────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(14),
                  border:
                      Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Search for a place...',
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 14),
                    prefixIcon:
                        const Icon(Icons.search, color: Colors.orange),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(Icons.clear,
                                color: Colors.white.withOpacity(0.5),
                                size: 18),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _results = [];
                                _hasSearched = false;
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onChanged: (v) {
                    setState(() {}); // refresh suffix icon
                    _search(v);
                  },
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Results / States ──────────────────────────────────────────
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.orange),
                    )
                  : _results.isEmpty && _hasSearched
                      ? _EmptyState(
                          query: _searchController.text,
                        )
                      : _results.isEmpty
                          ? _HintState()
                          : ListView.separated(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              itemCount: _results.length,
                              separatorBuilder: (_, __) => Divider(
                                color: Colors.white.withOpacity(0.07),
                                height: 1,
                              ),
                              itemBuilder: (ctx, i) {
                                final place = _results[i];
                                final name = _placeName(place);
                                final location = _placeLocation(place);
                                if (name.isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  leading: Container(
                                    padding: const EdgeInsets.all(9),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.location_on,
                                        color: Colors.orange, size: 18),
                                  ),
                                  title: Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
                                  subtitle: location.isNotEmpty
                                      ? Text(
                                          location,
                                          style: TextStyle(
                                            color: Colors.white
                                                .withOpacity(0.5),
                                            fontSize: 12,
                                          ),
                                        )
                                      : null,
                                  onTap: () {
                                    widget.onPlaceSelected(place);
                                    Navigator.pop(context);
                                  },
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HintState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.travel_explore,
              color: Colors.white.withOpacity(0.2), size: 64),
          const SizedBox(height: 12),
          Text(
            'Type to search places',
            style: TextStyle(
                color: Colors.white.withOpacity(0.4), fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String query;
  const _EmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_off,
              color: Colors.white.withOpacity(0.2), size: 64),
          const SizedBox(height: 12),
          Text(
            'No results for "$query"',
            style: TextStyle(
                color: Colors.white.withOpacity(0.4), fontSize: 15),
          ),
          const SizedBox(height: 6),
          Text(
            'Try a different search term',
            style: TextStyle(
                color: Colors.white.withOpacity(0.25), fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;

  const _SectionHeader({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.orange, size: 16),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.orange,
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _BookingCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String price;
  final IconData icon;
  final Color color;

  const _BookingCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (price.isNotEmpty)
            Text(
              price,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }
}

class _PlaceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDelete;

  const _PlaceCard({
    required this.title,
    required this.subtitle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: Colors.orange, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle.isNotEmpty)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
            onPressed: onDelete,
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

class _AddPlaceButton extends StatelessWidget {
  final VoidCallback onTap;

  const _AddPlaceButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.15),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_location_alt_outlined, color: Colors.orange, size: 20),
            SizedBox(width: 8),
            Text(
              'Add Place',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:egytravel_app/feature/guid_trip/logic/controller/guide_trip_controller.dart';
import 'package:egytravel_app/feature/guid_trip/logic/models/guide_day_model.dart';
import 'package:egytravel_app/feature/plan/data/repo/trip_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DayInputCard extends StatelessWidget {
  final GuideDayModel day;

  const DayInputCard({Key? key, required this.day}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    const SizedBox(height: 12),
                    _buildTextField(
                      label: 'Place',
                      icon: Icons.map,
                      controller: day.addressController,
                      readOnly: true,
                      onTap: () => _showPlaceSearchSheet(context),
                      onChanged: (_) {},
                    ),
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

import 'package:egytravel_app/feature/auth/ui/widgets/glass_container.dart';
import 'package:egytravel_app/feature/guid_trip/logic/models/guide_day_model.dart';
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
                day.isExpanded.value ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
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
                  onChanged: (value) {}, // Managed by search sheet
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
    final searchController = TextEditingController();
    final List<String> popularPlaces = [
      'Pyramids of Giza',
      'Karnak Temple',
      'Valley of the Kings',
      'Abu Simbel',
      'Egyptian Museum',
      'Khan el-Khalili',
      'Luxor Temple',
      'Philae Temple',
      'Siwa Oasis',
      'White Desert',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E).withOpacity(0.95),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border(
              top: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: TextField(
                  controller: searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search for a place...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                    prefixIcon: const Icon(Icons.search, color: Colors.orange),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    // Implement search logic here if needed
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: popularPlaces.length,
                  itemBuilder: (context, index) {
                    final place = popularPlaces[index];
                    return ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on, color: Colors.orange, size: 20),
                      ),
                      title: Text(
                        place,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      subtitle: Text(
                        'Egypt',
                        style: TextStyle(color: Colors.white.withOpacity(0.5)),
                      ),
                      onTap: () {
                        day.addressController.text = place;
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

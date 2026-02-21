import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_item_model.dart';
import 'package:flutter/material.dart';

class ExploreDetailsInfoGrid extends StatelessWidget {
  final ExploreItemModel item;

  const ExploreDetailsInfoGrid({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    items.add(
      _buildInfoItem("Category", item.category, Icons.category_outlined),
    );

    if (item.type == ExploreItemType.restaurant) {
      items.add(
        _buildInfoItem(
          "Cuisine",
          item.cuisine ?? "International",
          Icons.restaurant_menu,
        ),
      );
      items.add(_buildInfoItem("Open", "10 AM - 11 PM", Icons.access_time));
    } else if (item.type == ExploreItemType.flight) {
      items.add(
        _buildInfoItem("Date", item.date ?? "TBD", Icons.calendar_today),
      );
      items.add(_buildInfoItem("Class", item.category, Icons.flight_class));
    } else if (item.type == ExploreItemType.hotel) {
      items.add(_buildInfoItem("Features", "Wifi, Pool", Icons.pool));
      items.add(_buildInfoItem("Check-in", "12:00 PM", Icons.login));
    } else {
      items.add(_buildInfoItem("Duration", "2-3 Hours", Icons.timer_outlined));
      items.add(_buildInfoItem("Guide", "Available", Icons.group_outlined));
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items.take(3).map((w) => Expanded(child: w)).toList(),
    );
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColor.primary, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.white60),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

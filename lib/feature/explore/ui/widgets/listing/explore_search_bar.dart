import 'package:egytravel_app/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class ExploreSearchBar extends StatelessWidget {
  final VoidCallback onFilterPressed;
  final Function(String)? onChanged;

  const ExploreSearchBar({
    super.key,
    required this.onFilterPressed,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white70),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      onChanged: onChanged,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search...",
                        hintStyle: TextStyle(color: Colors.white60),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: onFilterPressed,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:egytravel_app/feature/home/logic/controller/home_controller.dart';

class SearchBarWidget extends StatelessWidget {
  final HomeController controller;

  const SearchBarWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller.searchController,
          decoration: InputDecoration(
            hintText: 'Search destinations...',
            hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 15),
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF64748B),
              size: 22,
            ),
            suffixIcon: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: controller.openFilter,
                icon: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
              ),
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
          ),
        ),
      ),
    );
  }
}

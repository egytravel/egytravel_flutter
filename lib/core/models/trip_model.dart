import 'package:egytravel_app/generated/assets.dart';

class Trip {
  final String id;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final String budget;
  final List<String> interests;
  final String imageUrl;
  final DateTime createdAt;
  final String source; // 'AI' or 'Manual'

  Trip({
    required this.id,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.budget,
    required this.interests,
    required this.imageUrl,
    required this.createdAt,
    required this.source,
  });

  // Calculate trip duration in days
  int get durationInDays => endDate.difference(startDate).inDays + 1;

  // Format date range as string
  String get dateRange {
    final startFormatted = '${startDate.day}/${startDate.month}';
    final endFormatted = '${endDate.day}/${endDate.month}/${endDate.year}';
    return '$startFormatted - $endFormatted';
  }

  // Mock data factory
  static List<Trip> getMockTrips() {
    return [
      Trip(
        id: '1',
        destination: 'Luxor',
        startDate: DateTime(2024, 3, 15),
        endDate: DateTime(2024, 3, 20),
        budget: 'Luxury',
        interests: ['Pyramids & Pharaonic', 'Museums', 'Culture'],
        imageUrl: Assets.imageOnboarding1,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        source: 'AI',
      ),
      Trip(
        id: '2',
        destination: 'Sharm El Sheikh',
        startDate: DateTime(2024, 4, 1),
        endDate: DateTime(2024, 4, 7),
        budget: 'Medium',
        interests: ['Beaches', 'Diving', 'Relaxation'],
        imageUrl: Assets.imageOnboarding2,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        source: 'Manual',
      ),
      Trip(
        id: '3',
        destination: 'Alexandria',
        startDate: DateTime(2024, 5, 10),
        endDate: DateTime(2024, 5, 14),
        budget: 'Budget',
        interests: ['History', 'Food', 'Culture'],
        imageUrl: Assets.imageOnboarding3,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        source: 'AI',
      ),
    ];
  }
}

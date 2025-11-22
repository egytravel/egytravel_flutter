import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripPlannerController extends GetxController {
  final destinationController = TextEditingController();
  final budgetController = TextEditingController();
  
  var currentStep = 0.obs; // 0: destination, 1: activities, 2: dates & budget, 3: results
  var selectedDestination = ''.obs;
  var selectedActivities = <String>[].obs;
  var selectedStartDate = Rx<DateTime?>(null);
  var selectedEndDate = Rx<DateTime?>(null);
  var selectedBudgetRange = ''.obs;
  var isGeneratingPlan = false.obs;
  var generatedItinerary = <ItineraryDay>[].obs;
  var showItinerary = false.obs;

  final List<String> popularDestinations = [
    'Cairo & Giza',
    'Luxor',
    'Aswan',
    'Alexandria',
    'Hurghada',
    'Sharm El Sheikh',
    'Dahab',
    'Siwa Oasis',
  ];

  final List<ActivityType> activityTypes = [
    ActivityType(
      'أثري وتاريخي',
      'Historical & Archaeological',
      Icons.account_balance,
      'استكشف المعابد والآثار الفرعونية العريقة',
      'historical',
    ),
    ActivityType(
      'بحري وترفيهي',
      'Marine & Entertainment',
      Icons.beach_access,
      'استمتع بالشواطئ والأنشطة المائية',
      'marine',
    ),
    ActivityType(
      'طبيعي ومغامرة',
      'Nature & Adventure',
      Icons.landscape,
      'اكتشف الصحراء والواحات والمحميات الطبيعية',
      'nature',
    ),
    ActivityType(
      'ثقافي وديني',
      'Cultural & Religious',
      Icons.mosque,
      'زيارة المساجد والكنائس والمواقع الدينية',
      'cultural',
    ),
  ];

  final List<BudgetRange> budgetRanges = [
    BudgetRange('Budget Explorer', '\$500 - \$1000', 'budget'),
    BudgetRange('Comfort Traveler', '\$1000 - \$2500', 'comfort'),
    BudgetRange('Luxury Adventurer', '\$2500 - \$5000', 'luxury'),
    BudgetRange('Royal Experience', '\$5000+', 'royal'),
  ];

  @override
  void onInit() {
    super.onInit();
    // Set default dates (today + 7 days for a week trip)
    selectedStartDate.value = DateTime.now().add(const Duration(days: 7));
    selectedEndDate.value = DateTime.now().add(const Duration(days: 14));
  }

  void selectDestination(String destination) {
    destinationController.text = destination;
    selectedDestination.value = destination;
  }

  void selectBudgetRange(String range) {
    selectedBudgetRange.value = range;
  }

  // Getters for widgets
  List<String> get destinations => popularDestinations;
  List<BudgetRange> get budgetOptions => budgetRanges;
  RxString get selectedBudget => selectedBudgetRange;
  
  bool get canGeneratePlan => 
      selectedDestination.value.isNotEmpty && 
      selectedBudgetRange.value.isNotEmpty &&
      !isGeneratingPlan.value;

  // Step navigation methods
  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void selectActivity(String activityId) {
    if (selectedActivities.contains(activityId)) {
      selectedActivities.remove(activityId);
    } else {
      selectedActivities.add(activityId);
    }
  }

  bool isActivitySelected(String activityId) {
    return selectedActivities.contains(activityId);
  }

  // Alias for generateTripPlan
  Future<void> generateItinerary() async {
    await generateTripPlan();
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFE09A1E),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedStartDate.value = picked;
      // Auto-set end date to 7 days later if not set
      if (selectedEndDate.value == null || selectedEndDate.value!.isBefore(picked)) {
        selectedEndDate.value = picked.add(const Duration(days: 7));
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate.value ?? selectedStartDate.value?.add(const Duration(days: 7)) ?? DateTime.now(),
      firstDate: selectedStartDate.value ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFFE09A1E),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      selectedEndDate.value = picked;
    }
  }

  int get tripDuration {
    if (selectedStartDate.value != null && selectedEndDate.value != null) {
      return selectedEndDate.value!.difference(selectedStartDate.value!).inDays + 1;
    }
    return 0;
  }

  Future<void> generateTripPlan() async {
    if (selectedDestination.value.isEmpty || selectedBudgetRange.value.isEmpty) {
      Get.snackbar(
        'Missing Information',
        'Please select destination and budget to generate your Egyptian adventure',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isGeneratingPlan.value = true;
    
    // Simulate AI planning process
    await Future.delayed(const Duration(seconds: 3));
    
    // Generate mock itinerary based on destination and duration
    generatedItinerary.value = _generateMockItinerary();
    showItinerary.value = true;
    isGeneratingPlan.value = false;

    Get.snackbar(
      'Trip Plan Ready!',
      'Your Egyptian adventure has been crafted by our AI travel expert 🏺',
      backgroundColor: const Color(0xFFE09A1E),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  List<ItineraryDay> _generateMockItinerary() {
    final destination = selectedDestination.value;
    final duration = tripDuration;
    final budget = selectedBudgetRange.value;
    
    List<ItineraryDay> itinerary = [];
    
    for (int i = 0; i < duration && i < 7; i++) {
      itinerary.add(_generateDayItinerary(i + 1, destination, budget));
    }
    
    return itinerary;
  }

  ItineraryDay _generateDayItinerary(int day, String destination, String budget) {
    // Mock data based on destination and budget
    Map<String, List<String>> destinationActivities = {
      'Cairo & Giza': [
        'Visit the Great Pyramids of Giza',
        'Explore the Egyptian Museum',
        'Walk through Khan El Khalili Bazaar',
        'Discover Islamic Cairo',
        'Nile River Cruise',
        'Visit Coptic Cairo',
        'Explore Saladin Citadel'
      ],
      'Luxor': [
        'Valley of the Kings Tour',
        'Karnak Temple Complex',
        'Luxor Temple at Sunset',
        'Hot Air Balloon Ride',
        'Hatshepsut Temple',
        'Colossi of Memnon',
        'Luxor Museum Visit'
      ],
      'Aswan': [
        'Philae Temple Visit',
        'Nubian Village Experience',
        'Felucca Sailing on the Nile',
        'Abu Simbel Day Trip',
        'Aswan High Dam',
        'Elephantine Island',
        'Botanical Garden Tour'
      ],
    };

    List<String> activities = destinationActivities[destination] ?? [
      'Explore Ancient Monuments',
      'Local Cultural Experience',
      'Traditional Egyptian Cuisine',
      'Desert Adventure',
      'Nile River Activities'
    ];

    String activity = activities[day % activities.length];
    String description = _getActivityDescription(activity, budget);
    String imageUrl = _getActivityImage(activity);

    return ItineraryDay(
      day: day,
      title: activity,
      description: description,
      imageUrl: imageUrl,
      duration: '4-6 hours',
      cost: _getActivityCost(budget),
    );
  }

  String _getActivityDescription(String activity, String budget) {
    Map<String, String> descriptions = {
      'Visit the Great Pyramids of Giza': 'Marvel at the last remaining Wonder of the Ancient World. Explore the Great Pyramid, Sphinx, and surrounding complex.',
      'Valley of the Kings Tour': 'Discover the royal tombs of ancient pharaohs including Tutankhamun and Ramesses II in this sacred valley.',
      'Philae Temple Visit': 'Experience the beautiful temple dedicated to Isis on Agilkia Island, relocated to save it from flooding.',
      'Explore Ancient Monuments': 'Immerse yourself in Egypt\'s rich history with guided tours of magnificent ancient structures.',
      'Local Cultural Experience': 'Connect with Egyptian culture through traditional music, dance, and local customs.',
    };
    
    return descriptions[activity] ?? 'An unforgettable Egyptian experience awaits you with expert local guides.';
  }

  String _getActivityImage(String activity) {
    // In a real app, these would be actual image URLs
    Map<String, String> images = {
      'Visit the Great Pyramids of Giza': 'assets/images/pyramids.jpg',
      'Valley of the Kings Tour': 'assets/images/valley_kings.jpg',
      'Philae Temple Visit': 'assets/images/philae.jpg',
    };
    
    return images[activity] ?? 'assets/images/egypt_default.jpg';
  }

  String _getActivityCost(String budget) {
    switch (budget) {
      case 'budget':
        return '\$50-80';
      case 'comfort':
        return '\$100-150';
      case 'luxury':
        return '\$200-300';
      case 'royal':
        return '\$400+';
      default:
        return '\$100';
    }
  }

  @override
  void onClose() {
    destinationController.dispose();
    budgetController.dispose();
    super.onClose();
  }
}

class BudgetRange {
  final String title;
  final String range;
  final String value;

  BudgetRange(this.title, this.range, this.value);
}

class ItineraryDay {
  final int day;
  final String title;
  final String description;
  final String imageUrl;
  final String duration;
  final String cost;

  ItineraryDay({
    required this.day,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.duration,
    required this.cost,
  });
}
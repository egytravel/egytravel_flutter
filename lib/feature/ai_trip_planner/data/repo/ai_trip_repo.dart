import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/ai_trip_planner/data/models/trip_plan_model.dart';

abstract class AiTripRepository {
  Future<TripPlanModel> generateTrip({
    required String city,
    required int days,
    required List<String> interests,
    required String budget,
    required DateTime startDate,
    required DateTime endDate,
    double? lat,
    double? lon,
  });
  Future<String> chatWithAi(String message, double lat, double lon);
}

class AiTripRepositoryImpl implements AiTripRepository {
  final ApiService _api = ApiService();

  @override
  Future<TripPlanModel> generateTrip({
    required String city,
    required int days,
    required List<String> interests,
    required String budget,
    required DateTime startDate,
    required DateTime endDate,
    double? lat,
    double? lon,
  }) async {
    final response = await _api.post(
      EndPoint.aiBaseUrl + EndPoint.aiPlan,
      data: {
        "city": city,
        "days": days,
        "interests": interests,
        "budget": budget,
        "start_date": _formatDate(startDate),
        "end_date": _formatDate(endDate),
        "user_id": "user_id",
        if (lat != null) "lat": lat,
        if (lon != null) "lon": lon,
      },
    );
    
    return TripPlanModel.fromJson(response);
  }

  @override
  Future<String> chatWithAi(String message, double lat, double lon) async {
    final response = await _api.post(
      EndPoint.aiBaseUrl + EndPoint.aiChat,
      data: {
        "message": message,
        "lat": lat,
        "lon": lon,
      },
    );
    
    final type = response['type'];
    final data = response['data'];

    if (type == 'chat') {
      if (data is Map) {
        return data['text'] ?? "No message text found";
      }
      return "Received chat type but data is not a map";
    } else if (type == 'places') {
      if (data is List) {
        if (data.isEmpty) return "I couldn't find any places matching your request.";
        
        String result = "I found these places for you:\n\n";
        for (var place in data) {
          final name = place['name'] ?? 'Unknown Place';
          final category = place['category'] ?? 'General';
          final description = place['description'] ?? 'No description available.';
          final distance = place['distance_km'];

          result += "📍 $name ($category)\n";
          result += "$description\n";
          if (distance != null) {
            result += "📏 Distance: ${distance.toStringAsFixed(2)} km\n";
          }
          result += "\n";
        }
        return result.trim();
      }
      return "Received places type but data is not a list";
    }
    
    // Fallback if data is just a string or has a 'text' field directly
    if (data is Map && data.containsKey('text')) {
      return data['text'];
    }
    
    return "I received an unexpected response format from the AI.";
  }

  String _formatDate(DateTime date) =>
      "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}

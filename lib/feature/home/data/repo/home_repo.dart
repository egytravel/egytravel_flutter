import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/home/data/model/event_model.dart';
import 'package:egytravel_app/feature/home/data/model/home_response_model.dart';

class HomeRepo {
  final ApiService _apiService = ApiService();

  Future<HomeResponse> getHomeData() async {
    final response = await _apiService.get(EndPoint.home);
    
    // Safely extract the 'data' map if the response is wrapped
    final data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as Map<String, dynamic>
        : response as Map<String, dynamic>;
        
    return HomeResponse.fromJson(data);
  }

  Future<List<EventModel>> getEvents() async {
    final response = await _apiService.get(EndPoint.events);
    
    final data = (response is Map<String, dynamic> && response.containsKey('data'))
        ? response['data'] as List
        : response as List;
        
    return data.map((e) => EventModel.fromJson(e)).toList();
  }
}

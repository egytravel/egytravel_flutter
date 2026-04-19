import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/home/data/model/home_response_model.dart';

class HomeRepo {
  final ApiService _apiService = ApiService();

  Future<HomeResponse> getHomeData() async {
    final response = await _apiService.get(EndPoint.home);
    return HomeResponse.fromJson(response.data['data']);
  }
}

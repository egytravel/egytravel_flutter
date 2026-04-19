import 'package:egytravel_app/core/network/api_service.dart';
import 'package:egytravel_app/core/network/end_point.dart';
import 'package:egytravel_app/feature/explore/data/model/explore_response_model.dart';

class ExploreRepo {
  final ApiService _apiService;

  ExploreRepo({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  Future<ExploreResponseModel> getExploreData() async {
    final response = await _apiService.get(EndPoint.explore);
    return ExploreResponseModel.fromJson(response.data);
  }
}

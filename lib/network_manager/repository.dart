import '../constant/api_constants.dart';
import '../model/HomeModel.dart';
import '../model/ReviewItem.dart';
import 'dio_helper.dart';

class Repository {
  final DioHelper _dioHelper = DioHelper();

 /* Future<MultipartFile> createMultipartFile(XFile file) async {
    if (kIsWeb) {
      final bytes = await file.readAsBytes();

      return MultipartFile.fromBytes(bytes, filename: file.name);
    } else {
      return MultipartFile.fromFile(file.path, filename: file.name);
    }
  }*/

  Future<HomeResponseModel> getHomeData({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required double lat,
    required double long,
  }) async {
    try {
      final response = await _dioHelper.post(
        url: ApiConstants.home,
        requestBody: {
          'user_id': userId,
          'access_token': accessToken,
          'service_category_id': serviceCategoryId,
          'lat': lat,
          'long': long,
        },
      );
      return HomeResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Get home data failed: $e');
    }
  }

  Future<ProviderReviewResponse> getProviderReview({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required int providerId,
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final response = await _dioHelper.post(
        url: ApiConstants.providerReview,
        requestBody: {
          'user_id': userId,
          'access_token': accessToken,
          'service_category_id': serviceCategoryId,
          'provider_id': providerId,
          'page': page,
          'per_page': perPage,
        },
      );
      return ProviderReviewResponse.fromJson(response);
    } catch (e) {
      throw Exception('Get provider reviews failed: $e');
    }
  }
}

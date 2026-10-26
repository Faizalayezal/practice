import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../constant/api_constants.dart';
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

 /* Future<RegisterResponse> register({required String mobileNo}) async {
    try {
      final response = await _dioHelper.post(
        url: ApiConstants.register,
        requestBody: {'mobileno': mobileNo},
      );
      return RegisterResponse.fromJson(response);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }


  Future<List<CategoryModel>> getCategory() async {
    try {


      final response = await _dioHelper.getList(url: ApiConstants.getCategory);

      return response.map((e) => CategoryModel.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Get category failed: $e');
    }
  }*/

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

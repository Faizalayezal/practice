import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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

  Future<RegisterResponse> register({required String mobileNo}) async {
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
  }









}

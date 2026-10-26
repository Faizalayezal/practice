import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constant/api_constants.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  factory DioClient() => _instance;

  late Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
        headers: {
          'Content-Type': 'application/json',
          'select-language': 'en',
          'select-currency': 'USD',
          'select-ip-address': '103.138.233.214',
          'select-time-zone': 'Asia/Calcutta',
        },
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("URL → ${options.uri}");

          if (options.data != null) {
            try {
              debugPrint("BODY → ${jsonEncode(options.data)}");
            } catch (_) {}
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint("RESPONSE → ${response.data}");
          return handler.next(response);
        },
        onError: (error, handler) async {
          debugPrint("ERROR → ${error.response?.data}");
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  /// 1. Home API
  Future<Response> getHomeData({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required double lat,
    required double long,
  }) async {
    return await dio.post(
      ApiConstants.home,
      data: {
        "user_id": userId,
        "access_token": accessToken,
        "service_category_id": serviceCategoryId,
        "lat": lat,
        "long": long,
      },
    );
  }

  /// 2. Provider Details API
  Future<Response> getProviderDetails({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required int providerId,
    required double lat,
    required double long,
    String? authorizationToken,
    String? selectLanguage,
    String? selectCurrency,
    String? selectIpAddress,
    String? selectTimeZone,
  }) async {
    final Map<String, dynamic> headers = {};
    if (authorizationToken != null && authorizationToken.isNotEmpty) {
      headers['Authorization'] = authorizationToken;
    }
    if (selectLanguage != null) headers['select-language'] = selectLanguage;
    if (selectCurrency != null) headers['select-currency'] = selectCurrency;
    if (selectIpAddress != null) headers['select-ip-address'] = selectIpAddress;
    if (selectTimeZone != null) headers['select-time-zone'] = selectTimeZone;

    return await dio.post(
      ApiConstants.providerDetails,
      data: {
        "user_id": userId,
        "access_token": accessToken,
        "service_category_id": serviceCategoryId,
        "provider_id": providerId,
        "lat": lat,
        "long": long,
      },
      options: headers.isNotEmpty ? Options(headers: headers) : null,
    );
  }

  /// 3. Provider Review API
  Future<Response> getProviderReview({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required int providerId,
    int page = 1,
    int perPage = 10,
  }) async {
    return await dio.post(
      ApiConstants.providerReview,
      data: {
        "user_id": userId,
        "access_token": accessToken,
        "service_category_id": serviceCategoryId,
        "provider_id": providerId,
        "page": page,
        "per_page": perPage,
      },
    );
  }

  /// 4. Provider Gallery API
  Future<Response> getProviderGallery({
    required int userId,
    required String accessToken,
    required int serviceCategoryId,
    required int providerId,
  }) async {
    return await dio.post(
      ApiConstants.providerGallery,
      data: {
        "user_id": userId,
        "access_token": accessToken,
        "service_category_id": serviceCategoryId,
        "provider_id": providerId,
      },
    );
  }
}

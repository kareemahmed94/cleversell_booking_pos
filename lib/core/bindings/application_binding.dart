import 'package:dio/dio.dart';
import 'package:get/get.dart';
// import 'package:htrk_player/core/services/constants.dart';
// import 'package:htrk_player/core/network/logging_interceptor.dart';

class ApplicationBinding implements Bindings {
  Dio _dio() {
    final options = BaseOptions(
      // baseUrl: URLs.apiUrl,
      // connectTimeout: AppLimit.REQUEST_TIME_OUT,
      // receiveTimeout: AppLimit.REQUEST_TIME_OUT,
      // sendTimeout: AppLimit.REQUEST_TIME_OUT,
    );

    var dio = Dio(options);

    // dio.interceptors.add(LoggingInterceptor());

    return dio;
  }

  @override
  void dependencies() {
    Get.lazyPut(
      _dio,
    );
  }
}
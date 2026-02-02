import 'package:dio/dio.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/repository/retrofit/Logging.dart';

class AppRepository {
  static Dio dio = Dio(
    BaseOptions(
        connectTimeout: 10000000,
        receiveTimeout: 10000000,
        baseUrl: AppConstants.base_api_url,
        contentType: "application/json"),
  )..interceptors.addAll([
    Logging()
  ]);
}

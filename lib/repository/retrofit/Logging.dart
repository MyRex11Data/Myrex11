import 'dart:developer';
import 'dart:io';
import 'package:myrex11/views/newUI/registerNew.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:myrex11/appUtilities/app_constants.dart';
import 'package:myrex11/customWidgets/app_circular_loader.dart';
import 'package:myrex11/localStoage/AppPrefrences.dart';

class Logging extends Interceptor {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Authorization'] = AppConstants.token;
    options.headers['Devicetype'] = Platform.isIOS
        ? 'IOS'
        : Platform.isAndroid
            ? 'ANDROID'
            : 'WEB';
    options.headers['Versioncode'] = AppConstants.versionCode;
    options.headers['Isplaystore'] = '1';
    options.headers['state'] =
        AppConstants.SHARED_PREFERENCE_USER_PLAYING_STATE_HEADER;
    options.headers['is_playstore_build'] = AppConstants.Is_PlayStoreBuild;

    final requestString = '''
      REQUEST METHOD: ${options.method}
      REQUEST URL: ${options.uri}
      REQUEST QUERY: ${options.queryParameters}
      REQUEST DATA: ${options.data}
       REQUEST HEADERS: ${options.headers}
    ''';

    debugPrint(requestString);

    return super.onRequest(options, handler);

    // debugPrint('REQUEST[${options.data}] => PATH: ${options.path} ');
    // debugPrint('HEADERS: ${options.headers} ');
    // print("API===> " + options.baseUrl + options.path);
    // return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    debugPrint(
      'RESPONSE[${response.data}] => PATH: ${response.requestOptions.path}',
    );

    final responseDetails = {
      'Response Data': inspect(response.data),
      'Path': response.requestOptions.path,
    };
    // Log the structured representation of the response details
    // log('RESPONSE: ${responseDetails}');
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    print(
      ["err.response========", err.response?.data],
    );

    // Check if response contains HTML (server error page)
    if (err.response?.data != null &&
        err.response!.data.toString().contains('<!DOCTYPE html>')) {
      print(
          '🚨 Server returned HTML error page instead of JSON. This indicates a server-side routing or configuration issue.');
      print('Request URL: ${err.response!.requestOptions.uri}');
      print('Status Code: ${err.response!.statusCode}');
    }

    if (err.response?.statusCode == 400) {
      AppPrefrence.clearPrefrence();
      Navigator.pushAndRemoveUntil(
          AppConstants.context,
          MaterialPageRoute(builder: (context) => new RegisterNew()),
          ModalRoute.withName("/main"));
    }
    AppConstants.onApiError = true;
    if (AppConstants.fromHomeScreen == false) {
      AppLoaderProgress.hideLoaderIOS(AppConstants.loderContext);
    }
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.response?.statusMessage}',
    );
    return super.onError(err, handler);
  }
}

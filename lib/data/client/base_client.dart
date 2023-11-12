import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mmd2/common/app.dart';
import 'package:mmd2/common/constants.dart';

class BaseClient {
  static Dio? _dio;

  Dio get dio {
    if (_dio == null) {
      _initialDio();
    }
    return _dio ?? Dio();
  }

  void _initialDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      )
    );

    _dio?.interceptors.add(InterceptorsWrapper(
      onRequest: (option, handler) {
        option.headers.addAll(App.additionHeader);
        return handler.next(option);
      },
      onResponse: (response, handler) {
        debugPrint(jsonEncode(response.data));
        return handler.next(response);
      },
      onError: (error, handler) {
        debugPrint(jsonEncode(error.response?.data));
        return handler.next(error);
      }
    ));
  }
}

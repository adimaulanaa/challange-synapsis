// ignore_for_file: unnecessary_null_comparison, avoid_print

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synapsis/config/string_resource.dart';
import 'package:synapsis/env.dart';
import 'package:synapsis/framework/core/exceptions/app_exceptions.dart';
import 'package:synapsis/framework/managers/helper.dart';

abstract class HttpManager {
  Future<dynamic> download({
    required String url,
    String path,
    Map<String, dynamic> query,
    required Map<String, String> headers,
  });

  Future<dynamic> get({
    required String url,
    Map<String, dynamic> query,
    required Map<String, String> headers,
  });

  Future<dynamic> post({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, dynamic> headers,
    FormData formData,
    bool isUploadImage = false,
  });

  Future<dynamic> put({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, String> headers,
    FormData formData,
    bool isUploadImage = false,
  });

  Future<dynamic> patch({
    String url,
    Map body,
    Map<String, dynamic> query,
    Map<String, String> headers,
    FormData formData,
  });

  Future<dynamic> delete({
    String url,
    Map<String, dynamic> query,
    Map<String, String> headers,
  });
}

class CustomInterceptors extends Interceptor {
  @override
  Future onRequest(options, handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    return onRequest(options, handler);
  }

  @override
  Future onResponse(response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    return onResponse(response, handler);
  }

  @override
  Future onError(DioError err, handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
    return onError(err, handler);
  }
}

class AppHttpManager implements HttpManager {
  static final AppHttpManager instance = AppHttpManager._instantiate();
  final String _baseUrl = Env().apiBaseUrl!;
  final Dio _dio = Dio();

  Duration _httpTimeout = const Duration(seconds: 60);
  Duration _httpUploadTimeout = const Duration(seconds: 15);

  // AppHttpManager() {
  //   _httpTimeout = Duration(seconds: Env().configHttpTimeout!);
  //   _httpUploadTimeout = Duration(seconds: Env().configHttpUploadTimeout!);
  //   _dio.options.baseUrl = _baseUrl;
  //   _dio.options.sendTimeout = 30000;
  //   _dio.interceptors.add(
  //     DioCacheManager(
  //       CacheConfig(baseUrl: _baseUrl),
  //     ).interceptor,
  //   );
  //   (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (HttpClient client) {
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  //     return client;
  //   };
  // }
  AppHttpManager._instantiate();
  static Future<PersistCookieJar> getCookiePath() async {
    Directory appDocDir = await getApplicationSupportDirectory();
    String appDocPath = appDocDir.path;
    return PersistCookieJar(
        ignoreExpires: true, storage: FileStorage(appDocPath));
  }

  // AppHttpManager._instantiate();
  AppHttpManager() {
    _httpTimeout = Duration(seconds: Env().configHttpTimeout!);
    _httpUploadTimeout = Duration(seconds: Env().configHttpUploadTimeout!);
    _dio.options.baseUrl = _baseUrl;
    // var cookieJar = await getCookiePath();
    // _dio.interceptors.add(
    //   CookieManager(cookieJar),
    // );
  }

  @override
  Future<dynamic> delete({
    String? url,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
  }) async {
    var cookieJar = await getCookiePath();
    _dio.interceptors.add(
      CookieManager(cookieJar),
    );

    try {
      if (Env().isInDebugMode) {
        print('Api Delete request url $url');
      }

      var cookieJar = await getCookiePath();
      printError(cookieJar);
      _dio.interceptors.add(
        CookieManager(cookieJar),
      );

      final response = await _dio.delete(_queryBuilder(url, query),
          options: Options(
            headers: _headerBuilder(headers),
          ));
      //     .timeout(_httpTimeout, onTimeout: () {
      //   throw NetworkException();
      // });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future get({
    String? url,
    Map<String, dynamic>? query,
    Map? body,
    required Map<String, String> headers,
  }) async {
    var cookieJar = await getCookiePath();
    _dio.interceptors.add(
      CookieManager(cookieJar),
    );

    try {
      if (Env().isInDebugMode) {
        printWarning('Api Get request url $url, with $query,  with $body');
      }

      final response = await _dio
          .get(
        _queryBuilder(url, query),
        data: body != null ? json.encode(body) : null,
      )
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future download({
    String? url,
    String? path,
    Map<String, dynamic>? query,
    required Map<String, String> headers,
  }) async {
    var cookieJar = await getCookiePath();
    _dio.interceptors.add(
      CookieManager(cookieJar),
    );

    try {
      final response = await _dio
          .download(
        _queryBuilder(url, query),
        path,
        options: Options(
          method: 'GET',
          headers: _headerBuilder(headers),
        ),
      )
          .timeout(_httpUploadTimeout, onTimeout: () {
        throw NetworkException();
      });

      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future<dynamic> post({
    String? url,
    Map? body,
    Map<String, dynamic>? query,
    Map<String, dynamic>? headers,
    FormData? formData,
    bool isUploadImage = false,
  }) async {
    var cookieJar = await getCookiePath();
    _dio.interceptors.add(
      CookieManager(cookieJar),
    );

    try {
      if (Env().isInDebugMode) {
        print('Api Post request url $url, with $body');
      }

      final response = await _dio
          .post(_queryBuilder(url, query),
              data: formData ?? (body != null ? json.encode(body) : null),
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout((isUploadImage) ? _httpUploadTimeout : _httpTimeout,
              onTimeout: () {
        throw NetworkException();
      });

      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future<dynamic> put({
    String? url,
    Map? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    FormData? formData,
    bool isUploadImage = false,
  }) async {
    var cookieJar = await getCookiePath();
    _dio.interceptors.add(
      CookieManager(cookieJar),
    );

    try {
      if (Env().isInDebugMode) {
        print('Api Put request url $url, with $body');
      }

      final response = await _dio
          .put(_queryBuilder(url, query),
              data: formData ?? (body != null ? json.encode(body) : null),
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  @override
  Future<dynamic> patch({
    String? url,
    Map? body,
    Map<String, dynamic>? query,
    Map<String, String>? headers,
    FormData? formData,
  }) async {
    var cookieJar = await getCookiePath();
    _dio.interceptors.add(
      CookieManager(cookieJar),
    );

    try {
      if (Env().isInDebugMode) {
        print('Api Patch request url $url, with $body');
      }

      final response = await _dio
          .patch(_queryBuilder(url, query),
              data: formData ?? (body != null ? json.encode(body) : null),
              options: Options(
                headers: _headerBuilder(headers),
              ))
          .timeout(_httpTimeout, onTimeout: () {
        throw NetworkException();
      });
      return _returnResponse(response);
    } catch (error) {
      return handleError(error);
    }
  }

  // private methods
  Map<String, dynamic> _headerBuilder(Map<String, dynamic>? headers) {
    headers ??= {};

    headers[HttpHeaders.acceptHeader] = 'application/json';
    if (headers[HttpHeaders.contentTypeHeader] == null) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }

    if (headers != null && headers.isNotEmpty) {
      headers.forEach((key, value) {
        headers?[key] = value;
      });
    }

    return headers;
  }

  String _queryBuilder(String? path, Map<String, dynamic>? query) {
    final buffer = StringBuffer();
    buffer.write(Env().apiBaseUrl! + path.toString());

    if (query != null) {
      if (query.isNotEmpty) {
        buffer.write('?');
      }
      query.forEach((key, value) {
        buffer.write('$key=$value&');
      });
    }
    if (Env().isInDebugMode) {
      print(buffer);
    }
    return buffer.toString();
  }

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, '');
  }

  dynamic _returnResponse(Response response) {
    var data = response;
    final responseJson = data;
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      if (Env().isInDebugMode) {
        print('Api response success uri ${response.realUri}');
        print('Api response success with $responseJson');
      }

      return responseJson;
    } else {
      handleError(response);
    }
  }

  Future<dynamic> handleError(dynamic error) async {
    if (error is DioError) {
      var response = error.response;
      if (Env().isInDebugMode) {
        print('Api response failed uri ${response!.realUri}');
        print('Api response failed with $response');
      }

      var message = '';
      try {
        message = response!.data['message'];
      } catch (e) {
        message = '';
      }

      if (message.isNotEmpty &&
          message.toUpperCase() == 'INVALID CREDENTIALS') {
        throw NotFoundException("User Tidak Terdaftar");
      } else if (message.isNotEmpty) {
        if (message.toUpperCase() == 'INVALID CREDENTIALS' ||
            message.toUpperCase() == 'MISSING AUTHENTICATION' ||
            message.toUpperCase() == 'FORBIDDEN') {
          if (Env().isInDebugMode) {
            print('Force Logout...');
          }

          throw InvalidCredentialException(
              "Sesi telah habis, harap login kembali");
        }
      } else if (response!.data.runtimeType == String) {
        message = removeAllHtmlTags(response.data);
        if (message.contains('502')) {
          // Bad Gateway
          message = '502 Bad Gateway';
        }
      }

      switch (response!.statusCode) {
        case 400:
          throw BadRequestException(
              message.isNotEmpty ? message : "Bad request");
        case 401:
          throw InvalidCredentialException(message.isNotEmpty
              ? StringResources.INVALID_CREDENTIAL_FAILURE_MESSAGE
              : StringResources.INVALID_CREDENTIAL_FAILURE_MESSAGE);
        case 403:
          throw UnauthorisedException(
              message.isNotEmpty ? message : "Invalid token");
        case 404:
          throw NotFoundException(message.isNotEmpty
              ? message == "User not registered"
                  ? "User Tidak Terdaftar"
                  : "Not Found"
              : "Not Found");
        case 422:
          throw UnauthorisedException(
              message.isNotEmpty ? message : "Invalid credentials");

        default:
          throw FetchDataException(
              message.isNotEmpty ? message : "Unknown Error");
      }
    }
  }
}

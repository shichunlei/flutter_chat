import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../commons/index.dart';
import '../model/base_entity.dart';

class HttpUtils {
  /// http request methods
  static const String GET = 'get';
  static const String POST = 'post';
  static const String DELETE = 'delete';

  Dio _dio;

  CancelToken cancelToken = CancelToken();

  Dio get dio => _dio;

  HttpUtils() {
    /// 或者通过传递一个 `options`来创建dio实例
    BaseOptions options = BaseOptions(
      /// 请求基地址,可以包含子路径，如: "https://www.google.com/api/".
      baseUrl: APIs.BASE_URL,

      /// 连接服务器超时时间，单位是毫秒.
      connectTimeout: 15000,

      /// 接收数据的总时限.
      receiveTimeout: 15000,

      /// [表示期望以那种格式(方式)接受响应数据。接受四种类型 `json`, `stream`, `plain`, `bytes`. 默认值是 `json`](https://github.com/flutterchina/dio/issues/30)
      responseType: ResponseType.plain,
    );

    _dio = Dio(options);

    /// 添加拦截器
    _dio.interceptors
      ..add(InterceptorsWrapper(
        /// 请求时的处理
        onRequest: (RequestOptions options) {
          debugPrint("\n================== 请求数据 ==========================");
          debugPrint("url = ${options.uri.toString()}");
          debugPrint("data = ${options.data}");
          debugPrint("queryParameters = ${options.queryParameters}");
          debugPrint("method = ${options.method}");

          options.headers..addAll({"version": "1.0.0"});

          debugPrint("headers = ${options.headers}");
        },

        /// 响应时的处理
        onResponse: (Response response) {
          debugPrint("\n================== 响应数据 ==========================");
          debugPrint("code = ${response.statusCode}");
          debugPrint("data = ${response.data}");
          debugPrint("\n");
        },
        onError: (DioError e) {
          debugPrint("\n================== 错误响应数据 ======================");
          debugPrint("type = ${e.type}");
          debugPrint("error = ${e.error}");
          debugPrint("message = ${e.message}");
          debugPrint("\n");
        },
      ))

      /// 添加 LogInterceptor 拦截器来自动打印请求、响应日志
      ..add(LogInterceptor(
        request: false,
        responseBody: true,
        responseHeader: false,
        requestHeader: false,
      ));
  }

  Future<Response> download(url, savePath,
      {Function(int count, int total) onReceiveProgress,
      CancelToken cancelToken}) async {
    debugPrint('download请求启动! url：$url');
    Response response;
    try {
      response = await Dio().download(
        url,
        savePath,
        cancelToken: cancelToken,
        onReceiveProgress: (int count, int total) {
          debugPrint(
              'onReceiveProgress: ${(count / total * 100).toStringAsFixed(0)} %');

          onReceiveProgress(count, total);
        },
      );
    } on DioError catch (e) {
      debugPrint(e.response.toString());
      formatError(e);
    }

    return response;
  }

  /// error统一处理
  void formatError(DioError e) {
    if (e.type == DioErrorType.CONNECT_TIMEOUT) {
      // It occurs when url is opened timeout.
      debugPrint("连接超时 Ծ‸ Ծ");
    } else if (e.type == DioErrorType.SEND_TIMEOUT) {
      // It occurs when url is sent timeout.
      debugPrint("请求超时 Ծ‸ Ծ");
    } else if (e.type == DioErrorType.RECEIVE_TIMEOUT) {
      //It occurs when receiving timeout
      debugPrint("响应超时 Ծ‸ Ծ");
    } else if (e.type == DioErrorType.RESPONSE) {
      // When the server response, but with a incorrect status, such as 404, 503...
      debugPrint("出现异常 Ծ‸ Ծ");
    } else if (e.type == DioErrorType.CANCEL) {
      // When the request is cancelled, dio will throw a error with this type.
      debugPrint("请求取消 Ծ‸ Ծ");
    } else {
      //DEFAULT Default error type, Some other Error. In this case, you can read the DioError.error if it is not null.
      debugPrint("未知错误 Ծ‸ Ծ");
    }
  }

  /// 取消请求
  ///
  /// 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。所以参数可选
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  get(
    String path,
    Function successCallBack, {
    Map<String, dynamic> params,
    CancelToken cancelToken,
    Function(BaseResult error) errorCallBack,
  }) async {
    _request(path, successCallBack,
        method: GET,
        params: params,
        errorCallBack: errorCallBack,
        cancelToken: cancelToken);
  }

  post(
    String path,
    Function successCallBack, {
    FormData params,
    CancelToken cancelToken,
    Function(BaseResult error) errorCallBack,
  }) async {
    _request(path, successCallBack,
        method: POST,
        params: params,
        errorCallBack: errorCallBack,
        cancelToken: cancelToken);
  }

  delete(
    String path,
    Function successCallBack, {
    Map<String, dynamic> params,
    CancelToken cancelToken,
    Function(BaseResult error) errorCallBack,
  }) async {
    _request(path, successCallBack,
        method: DELETE,
        params: params,
        errorCallBack: errorCallBack,
        cancelToken: cancelToken);
  }

  _request(
    String path,
    Function successCallBack, {
    @required String method,
    dynamic params,
    Function(BaseResult error) errorCallBack,
    CancelToken cancelToken,
  }) async {
    Response response;
    try {
      if (method == GET) {
        if (null != params && params.isNotEmpty) {
          response = await dio.get(
            path,
            queryParameters: params,
            cancelToken: cancelToken,
          );
        } else {
          response = await dio.get(
            path,
            cancelToken: cancelToken,
          );
        }
      } else if (method == POST) {
        response = await dio.post(
          path,
          data: params,
          onSendProgress: (int count, int total) {
            debugPrint(
                'onSendProgress: ${(count / total * 100).toStringAsFixed(0)} %');
          },
          cancelToken: cancelToken,
        );
      } else if (method == DELETE) {
        response = await dio.delete(
          path,
          queryParameters: params,
          cancelToken: cancelToken,
        );
      }
    } on DioError catch (error) {
      // 请求错误处理
      debugPrint(error.response.toString());
      formatError(error);
      _error(
          errorCallBack,
          BaseResult(
              message: error.message.toString(),
              code: error.response.statusCode.toString()));
    }
    if (response != null &&
        response.statusCode >= 200 &&
        response.statusCode < 300) {
      BaseResult result = BaseResult.fromMap(json.decode(response.data));
      if (result == null || result.code != '0') {
        _error(errorCallBack, result);
      } else if (successCallBack != null) {
        successCallBack(result.data);
      }
    } else {
      _error(
          errorCallBack,
          BaseResult(
              message: response.data.toString(),
              code: response.statusCode.toString()));
    }
  }

  _error(Function(BaseResult error) errorCallBack, BaseResult error) {
    if (errorCallBack != null) {
      errorCallBack(error);
    }
  }
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:listar_flutter_pro/blocs/bloc.dart';
import 'package:listar_flutter_pro/configs/config.dart';
import 'package:listar_flutter_pro/models/model.dart';
import 'package:listar_flutter_pro/utils/logger.dart';

Map<String, dynamic> dioErrorHandle(DioError error) {
  UtilLogger.log("ERROR", error);

  switch (error.type) {
    case DioErrorType.response:
      UtilLogger.log("DioErrorType.response", error.response);
      if (error.response!.data is Map<String, dynamic>) {
        return error.response!.data;
      }
      return {"success": false, "message": "json_format_error"};
    case DioErrorType.sendTimeout:
    case DioErrorType.receiveTimeout:
      return {"success": false, "message": "request_time_out"};

    default:
      return {"success": false, "message": "connect_to_server_fail"};
  }
}

class HTTPManager {
  BaseOptions baseOptions = BaseOptions(
    baseUrl: "http://listar.passionui.com/index.php/wp-json",
    connectTimeout: 3000,
    receiveTimeout: 3000,
    headers: {},
    contentType: Headers.jsonContentType,
    responseType: ResponseType.json,
  );
  ///Setup Option
  BaseOptions exportOption(BaseOptions options) {
    Map<String, dynamic> header = {
      "Device-Id": Application.device?.uuid ?? '',
      "Device-Name": utf8.encode(Application.device?.name ?? ''),
      "Device-Model": Application.device?.model ?? '',
      "Device-Version": Application.device?.version ?? '',
      "Push-Token": Application.device?.token ?? '',
      "Type": Application.device?.type ?? '',
      "Lang": AppBloc.languageCubit.state.languageCode,
    };
    options.headers.addAll(header);
    UserModel? user = AppBloc.userCubit.state;
    if (user == null) {
      options.headers.remove("Authorization");
    } else {
      options.headers["Authorization"] = "Bearer ${user.token}";
    }
    return options;
  }

  ///Post method
  Future<dynamic> post({
    required String url,
    Map<String, dynamic>? data,
    FormData? formData,
    Options? options,
    Function(num)? progress,
  }) async {
    UtilLogger.log("POST URL", url);
    UtilLogger.log("DATA", data ?? formData);
    BaseOptions requestOptions = exportOption(baseOptions);
    UtilLogger.log("HEADERS", requestOptions.headers);

    Dio dio = Dio(requestOptions);
    try {
      final response = await dio.post(
        url,
        data: data ?? formData,
        options: options,
        onSendProgress: (sent, total) {
          if (progress != null) {
            progress((sent / total) / 0.01);
          }
        },
      );
      return response.data;
    } on DioError catch (error) {
      return dioErrorHandle(error);
    }
  }

  ///Get method
  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? params,
    Options? options,
  }) async {
    UtilLogger.log("GET URL", url);
    UtilLogger.log("PARAMS", params);
    BaseOptions requestOptions = exportOption(baseOptions);
    UtilLogger.log("HEADERS", requestOptions.headers);

    Dio dio = Dio(requestOptions);

    try {
      final response = await dio.get(
        url,
        queryParameters: params,
      );
      return response.data;
    } on DioError catch (error) {
      return dioErrorHandle(error);
    }
  }

  factory HTTPManager() {
    return HTTPManager._internal();
  }

  HTTPManager._internal();
}

HTTPManager httpManager = HTTPManager();

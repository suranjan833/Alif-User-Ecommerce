// ignore_for_file: library_prefixes

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as DIO;

import 'app_config.dart';

Map<String, String> _getHeaders() {
  final token = getBox.read(USER_TOKEN) ?? '';
  return {
    'Cache-Control': 'no-cache, no-store, must-revalidate',
    'Pragma': 'no-cache',
    'Expires': '0',
    if (token.toString().isNotEmpty) 'authtoken': token.toString(),
    if (token.toString().isNotEmpty) 'Authorization': 'Bearer $token',
  };
}

Future<DIO.Response<dynamic>> dioGet(String endUrl) async {
  var dio = DIO.Dio();
  dio.options.headers = _getHeaders();
  var finalUrl = "$BASE_URL$endUrl";

  try {
    var response = await dio.get(
      finalUrl,
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    if (isDebugMode.value) {
      log("\n\nGET: $finalUrl\nHEADERS:\n${jsonEncode(_getHeaders())}\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n");
    }
    return response;
  } catch (e) {
    return DIO.Response(
      requestOptions: DIO.RequestOptions(path: endUrl),
      statusCode: 500,
      statusMessage: "Something went wrong",
      data: {"message": "Something went wrong"},
    );
  }
}

Future<DIO.Response<dynamic>> dioDelete(String endUrl) async {
  var dio = DIO.Dio();
  dio.options.headers = _getHeaders();
  var finalUrl = "$BASE_URL$endUrl";

  try {
    var response = await dio.delete(
      finalUrl,
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    if (isDebugMode.value) {
      log("\n\nDELETE: $finalUrl\nHEADERS:\n${jsonEncode(_getHeaders())}\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n");
    }
    return response;
  } catch (e) {
    return DIO.Response(
      requestOptions: DIO.RequestOptions(path: endUrl),
      statusCode: 500,
      statusMessage: "Something went wrong",
      data: {"message": "Something went wrong"},
    );
  }
}

Future<DIO.Response<dynamic>> dioPost({
  Map<String, dynamic>? data,
  String? endUrl,
  bool? isFile,
  bool isJson = false,
}) async {
  var finalUrl = "$BASE_URL${endUrl ?? ''}";
  var dio = DIO.Dio();
  dio.options.headers = _getHeaders();
  if (isJson) {
    dio.options.headers['Content-Type'] = 'application/json';
  }
  try {
    var response = await dio.post(
      finalUrl,
      data: isJson ? (data ?? {}) : (data != null ? DIO.FormData.fromMap(data) : null),
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: isJson ? DIO.Headers.jsonContentType : null,
      ),
    );
    if (isDebugMode.value) {
      log("\n\nPOST: $finalUrl\nHEADERS:\n${jsonEncode(_getHeaders())}\n${(isFile ?? false) ? '' : 'BODY:${jsonEncode(data)}'}\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n");
    }
    return response;
  } catch (e) {
    log(e.toString());
    return DIO.Response(
      requestOptions: DIO.RequestOptions(path: endUrl ?? ""),
      statusCode: 500,
      statusMessage: "Something went wrong",
      data: {"message": "Something went wrong"},
    );
  }
}

Future<DIO.Response<dynamic>> dioPut({
  Map<String, dynamic>? data,
  String? endUrl,
  bool isJson = true,
}) async {
  var finalUrl = "$BASE_URL${endUrl ?? ''}";
  var dio = DIO.Dio();
  dio.options.headers = _getHeaders();
  if (isJson) {
    dio.options.headers['Content-Type'] = 'application/json';
  }
  try {
    var response = await dio.put(
      finalUrl,
      data: isJson ? (data ?? {}) : (data != null ? DIO.FormData.fromMap(data) : null),
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: isJson ? DIO.Headers.jsonContentType : null,
      ),
    );
    if (isDebugMode.value) {
      log("\n\nPUT: $finalUrl\nHEADERS:\n${jsonEncode(_getHeaders())}\nBODY:${jsonEncode(data)}\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n");
    }
    return response;
  } catch (e) {
    log(e.toString());
    return DIO.Response(
      requestOptions: DIO.RequestOptions(path: endUrl ?? ""),
      statusCode: 500,
      statusMessage: "Something went wrong",
      data: {"message": "Something went wrong"},
    );
  }
}

Future<DIO.Response<dynamic>> dioPatch({
  Map<String, dynamic>? data,
  String? endUrl,
  bool isJson = true,
}) async {
  var finalUrl = "$BASE_URL${endUrl ?? ''}";
  var dio = DIO.Dio();
  dio.options.headers = _getHeaders();
  if (isJson) {
    dio.options.headers['Content-Type'] = 'application/json';
  }
  try {
    var response = await dio.patch(
      finalUrl,
      data: isJson ? (data ?? {}) : (data != null ? DIO.FormData.fromMap(data) : null),
      options: DIO.Options(
        validateStatus: (status) => true,
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: isJson ? DIO.Headers.jsonContentType : null,
      ),
    );
    if (isDebugMode.value) {
      log("\n\nPATCH: $finalUrl\nHEADERS:\n${jsonEncode(_getHeaders())}\nBODY:${jsonEncode(data)}\nSTATUS CODE: ${response.statusCode}\n${jsonEncode(response.data)}\n\n");
    }
    return response;
  } catch (e) {
    log(e.toString());
    return DIO.Response(
      requestOptions: DIO.RequestOptions(path: endUrl ?? ""),
      statusCode: 500,
      statusMessage: "Something went wrong",
      data: {"message": "Something went wrong"},
    );
  }
}

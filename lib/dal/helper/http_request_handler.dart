import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:upday_task/dal/model/response/http_response_wrapper.dart';
import 'package:upday_task/settings/app_settings.dart';

/// This class is SINGLETON, it is handling logic for CRUD operations
/// After you create instance of it, please SETUP which module do you want
/// to use, if you didn't specify module, method will setup up module trip
/// for use. Full list of modules you have in settings => region "modules"
class AppHttpRequestHandler {
  static final AppHttpRequestHandler _instance =
      AppHttpRequestHandler._internal();

  factory AppHttpRequestHandler() => _instance;

  /// private, named constructor
  AppHttpRequestHandler._internal();

  HttpClient httpClient = HttpClient();
  String baseUri = AppSettings.API_BASE_URI;

  /// Helper method for universal GET, after call you need to map response to
  /// your model, be aware that you can get error code from response so you need
  /// to wrap your call of this method with try catch block of code
  Future<HttpResponseWrapper> getHttp(
      {String path = '', Map<String, String> queryParameters, var body}) async {
    HttpClientRequest request;
    Uri uri;
    try {
      final String basePath = baseUri;
      uri = Uri.https(basePath, path, queryParameters);

      request = await httpClient.getUrl(uri);
      request.headers.set(HttpHeaders.authorizationHeader,
          'Basic ${base64Encode(utf8.encode('5af67-e0db5-44eb6-abf2e-3171a-94137:95ecb-1651e-c7698-3e36e-3c935-6361d'))}');

      final HttpClientResponse response = await request.close();

      final String responseString =
          await response.transform(utf8.decoder).join();

      if (!isStatusCodeSuccess(response.statusCode)) {
//        throw Exception(ErrorHandler.fromHttpRequest(response.statusCode,
//            responseBody: responseString));
        throw Exception('HTTP error code');
      }

      return HttpResponseWrapper(
          body: responseString, headers: response.headers);
    } catch (e) {
      throw e;
    }
  }

  /// Returns true for every success HTTP code
  bool isStatusCodeSuccess(int currentStatusCode) {
    switch (currentStatusCode) {
      case HttpStatus.ok:
      case HttpStatus.created:
      case HttpStatus.accepted:
      case HttpStatus.nonAuthoritativeInformation:
      case HttpStatus.noContent:
      case HttpStatus.resetContent:
      case HttpStatus.partialContent:
      case HttpStatus.multiStatus:
      case HttpStatus.alreadyReported:
      case HttpStatus.imUsed:
        return true;
        break;
    }

    return false;
  }
}

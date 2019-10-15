import 'dart:io';

import 'package:meta/meta.dart';

class HttpResponseWrapper {
  final String body;
  final HttpHeaders headers;

  HttpResponseWrapper({@required this.body, this.headers});
}

// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:extended_http_client/src/http/http.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

abstract class HttpClientEx implements HttpClient {
  factory HttpClientEx({SecurityContext? context}) => createHttpClient(context);
}

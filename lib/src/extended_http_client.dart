// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:extended_http_client/extended_http_client.dart';
import 'package:extended_http_client/src/http/http.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

abstract class HttpClientEx implements HttpClient {
  factory HttpClientEx({SecurityContext? context}) => createHttpClient(context);
}

abstract class HttpClientExCredentials implements HttpClientCredentials {}

/// Represents credentials for basic authentication.
abstract class HttpClientExBasicCredentials extends HttpClientExCredentials {
  factory HttpClientExBasicCredentials(String username, String password) =>
      createHttpClientBasicCredentials(username, password);

  String get username;
  String get password;
}

/// Represents credentials for digest authentication. Digest
/// authentication is only supported for servers using the MD5
/// algorithm and quality of protection (qop) of either "none" or
/// "auth".
abstract class HttpClientExDigestCredentials extends HttpClientExCredentials {
  factory HttpClientExDigestCredentials(String username, String password) =>
      createHttpClientDigestCredentials(username, password);

  String get username;
  String get password;
}

/// Represents credentials for NTLM authentication.
abstract class HttpClientExNtlmCredentials extends HttpClientExCredentials {
  factory HttpClientExNtlmCredentials(NtlmCredentials credentials) => createHttpClientNtlmCredentials(credentials);

  NtlmCredentials get credentials;
}

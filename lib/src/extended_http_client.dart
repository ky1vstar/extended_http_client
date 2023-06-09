// TODO: Put public facing types in this file.

import 'dart:io';

import 'package:delayed_proxy_http_client/delayed_proxy_http_client.dart';
import 'package:extended_http_client/extended_http_client.dart';
import 'package:extended_http_client/src/http/http.dart';

/// Checks if you are awesome. Spoiler: you are.
class Awesome {
  bool get isAwesome => true;
}

abstract class HttpClientEx implements DelayedProxyHttpClient {
  factory HttpClientEx({SecurityContext? context}) => createHttpClient(context);

  /// Add credentials to be used for authorizing HTTP requests.
  @override
  @Deprecated("Use addCredentialsEx instead.")
  void addCredentials(Uri url, String realm, HttpClientCredentials credentials);

  /// Add credentials to be used for authorizing HTTP requests.
  void addCredentialsEx(Uri url, String realm, HttpClientExCredentials credentials);

  /// Add credentials to be used for authorizing HTTP proxies.
  @override
  @Deprecated("Use addProxyCredentialsEx instead.")
  void addProxyCredentials(String host, int port, String realm, HttpClientCredentials credentials);

  /// Add credentials to be used for authorizing HTTP proxies.
  void addProxyCredentialsEx(String host, int port, String realm, HttpClientExCredentials credentials);
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

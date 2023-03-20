1. Copy dart-sdk/sdk/lib/_http/http_impl.dart -> dart_sdk_http/http_impl.dart
2. Copy dart-sdk/sdk/lib/_http/http_headers.dart -> dart_sdk_http/http_headers.dart
3. Copy dart-sdk/sdk/lib/_http/http_parser.dart -> dart_sdk_http/http_parser.dart
4. Copy dart-sdk/sdk/lib/_http/http_session.dart -> dart_sdk_http/http_session.dart
5. Copy dart-sdk/sdk/lib/_http/crypto.dart -> dart_sdk_http/crypto.dart
6. Copy dart-sdk/sdk/lib/_http/embedder_config.dart -> dart_sdk_http/embedder_config.dart
7. Replace `part of dart._http;` to `part of '../http.dart';` among all copied files
8. Copy static method `HttpDate._parseCookieDate` from dart-sdk/sdk/lib/_http/http_date.dart as top level method `_HttpDate_parseCookieDate` to dart_sdk_http/http_date.dart
9. Copy `checkNotNullable` method, `NotNullableError` class and `valueOfNonNullableParamWithDefault` method from sdk/lib/internal/internal.dart -> dart_sdk_internal/internal.dart
10. dart_sdk_http/http_impl.dart: comment out `_HttpServer.bind` and `_HttpServer.bindSecure` static methods
11. dart_sdk_http/http_impl.dart: let `_HttpClient` implement `HttpClientEx`

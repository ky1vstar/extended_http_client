import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:extended_http_client/extended_http_client.dart'
    show
        HttpClientEx,
        HttpClientExCredentials,
        HttpClientExBasicCredentials,
        HttpClientExDigestCredentials,
        HttpClientExNtlmCredentials,
        NtlmCredentials,
        NtlmSecurityContext;

part 'dart_sdk_http/crypto.dart';
part 'dart_sdk_http/embedder_config.dart';
part 'dart_sdk_http/http_impl.dart';
part 'dart_sdk_http/http_date.dart';
part 'dart_sdk_http/http_headers.dart';
part 'dart_sdk_http/http_parser.dart';
part 'dart_sdk_http/http_session.dart';
part 'dart_sdk_internal/internal.dart';

HttpClientEx createHttpClient(SecurityContext? context) => _HttpClient(context);

HttpClientExBasicCredentials createHttpClientBasicCredentials(String username, String password) =>
    _HttpClientExBasicCredentials(username, password);

HttpClientExDigestCredentials createHttpClientDigestCredentials(String username, String password) =>
    _HttpClientExDigestCredentials(username, password);

HttpClientExNtlmCredentials createHttpClientNtlmCredentials(NtlmCredentials credentials) =>
    _HttpClientNtlmCredentials(credentials);

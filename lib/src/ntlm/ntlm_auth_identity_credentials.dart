import 'dart:typed_data';

import 'package:extended_http_client/src/ntlm/messages/messages.dart';
import 'package:extended_http_client/src/ntlm/ntlm_credentials.dart';

class NtlmAuthIdentityCredentials implements NtlmCredentials {
  /// The NT domain used by this client to authenticate
  final String domain;

  /// The NT workstation used by this client to authenticate
  final String workstation;

  /// The username of the user trying to authenticate
  final String username;

  /// The password of the user trying to authenticate
  final String? password;

  /// The lan manager hash of the user's password
  final String? lmPassword;

  /// The NT hash of the user's password
  final String? ntPassword;

  /// Creates a new NTLM inline credentials
  ///
  /// The [username] is required as is either the [password]...
  ///
  /// ```dart
  /// NtlmCredentials credentials = NtlmAuthIdentityCredentials(
  ///   username: "User208",
  ///   password: "password",
  /// );
  /// ```
  ///
  /// ...or the [lmPassword] and the [ntPassword] in base 64 form.
  ///
  /// ```dart
  /// String lmPassword = lmHash("password");
  /// String ntPassword = ntHash("password");
  ///
  /// NtlmCredentials credentials = NtlmAuthIdentityCredentials(
  ///   username: "User208",
  ///   lmPassword: lmPassword,
  ///   ntPassword: ntPassword,
  /// );
  /// ```
  NtlmAuthIdentityCredentials({
    this.domain = '',
    this.workstation = '',
    required this.username,
    this.password,
    this.lmPassword,
    this.ntPassword,
  }) : assert(
          password != null || (lmPassword != null && ntPassword != null),
          'You must provide a password or the LM and NT hash of a password.',
        );

  @override
  NtlmSecurityContext initializeSecurityContext() => NtlmAuthIdentitySecurityContext(
        domain: domain,
        workstation: workstation,
        username: username,
        password: password,
        lmPassword: lmPassword,
        ntPassword: ntPassword,
      );
}

class NtlmAuthIdentitySecurityContext implements NtlmSecurityContext {
  final String domain;
  final String workstation;
  final String username;
  final String? password;
  final String? lmPassword;
  final String? ntPassword;

  NtlmAuthIdentitySecurityContext({
    required this.domain,
    required this.workstation,
    required this.username,
    required this.password,
    required this.lmPassword,
    required this.ntPassword,
  }) : assert(
          password != null || (lmPassword != null && ntPassword != null),
          'You must provide a password or the LM and NT hash of a password.',
        );

  @override
  Uint8List getTokenBytes(Uint8List? challengeBytes) {
    if (challengeBytes == null) {
      return createType1Message(domain: domain, workstation: workstation);
    } else {
      final msg2 = parseType2Message(challengeBytes);
      return createType3Message(
        msg2,
        domain: domain,
        workstation: workstation,
        username: username,
        password: password,
        lmPassword: lmPassword,
        ntPassword: ntPassword,
      );
    }
  }

  @override
  void dispose() {}
}

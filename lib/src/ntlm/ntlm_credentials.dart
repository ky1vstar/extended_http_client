import 'dart:typed_data';

abstract class NtlmCredentials {
  NtlmSecurityContext initializeSecurityContext();
}

abstract class NtlmSecurityContext {
  Uint8List getTokenBytes(Uint8List? challengeBytes);

  void dispose();
}

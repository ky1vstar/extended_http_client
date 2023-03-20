import 'dart:ffi';
import 'dart:typed_data';

import 'package:extended_http_client/src/ntlm/ntlm_credentials.dart';
import 'package:extended_http_client/src/sspi/bindings.g.dart';
import 'package:ffi/ffi.dart';

class NtlmSspiCredentials implements NtlmCredentials {
  @override
  NtlmSspiSecurityContext initializeSecurityContext() => NtlmSspiSecurityContext();
}

class NtlmSspiSecurityContext implements NtlmSecurityContext {
  static final _dylib = DynamicLibrary.open("Secur32.dll");
  static final _sspi = SspiBindings(_dylib);

  static final Pointer<SecHandle> _credentials = (() {
    final credentials = calloc<SecHandle>();
    final package = "NTLM".toNativeUtf16();

    try {
      final status = _sspi.AcquireCredentialsHandleW(
        nullptr,
        package.cast(),
        SECPKG_CRED_OUTBOUND,
        nullptr,
        nullptr,
        nullptr,
        nullptr,
        credentials,
        nullptr,
      );

      print("AcquireCredentialsHandleW status $status");

      if (status != SEC_E_OK) {
        throw StateError("Status #1 $status");
      }

      return credentials;
    } on Object catch (_) {
      malloc.free(credentials);
      rethrow;
    } finally {
      malloc.free(package);
    }
  })();

  final _context = calloc<SecHandle>();
  var _hasContext = false;
  var _isDisposed = false;

  @override
  Uint8List getTokenBytes(Uint8List? challengeBytes) {
    assert(!_isDisposed);
    if (_isDisposed) return Uint8List(0);

    return using((arena) {
      var challengeDesc = nullptr.cast<SecBufferDesc>();
      if (challengeBytes != null) {
        final challengeBuf = arena.allocate(challengeBytes.length);
        challengeBuf.cast<Uint8>().asTypedList(challengeBytes.length).setAll(0, challengeBytes);

        challengeDesc = arena<SecBufferDesc>();
        final challenge = arena<SecBuffer>();

        challengeDesc.ref.ulVersion = SECBUFFER_VERSION;
        challengeDesc.ref.cBuffers = 1;
        challengeDesc.ref.pBuffers = challenge;

        challenge.ref.BufferType = SECBUFFER_TOKEN;
        challenge.ref.pvBuffer = challengeBuf.cast();
        challenge.ref.cbBuffer = challengeBytes.length;
      }

      final tokenDesc = arena<SecBufferDesc>();
      final token = arena<SecBuffer>();
      tokenDesc.ref.ulVersion = SECBUFFER_VERSION;
      tokenDesc.ref.cBuffers = 1;
      tokenDesc.ref.pBuffers = token;
      token.ref.BufferType = SECBUFFER_TOKEN;

      arena.using(token, (_) {
        if (token.ref.pvBuffer != nullptr && token.ref.cbBuffer > 0) {
          _sspi.FreeContextBuffer(token.ref.pvBuffer);
        }
      });

      final attrs = arena<UnsignedInt>();
      final expiry = arena<SECURITY_INTEGER>();

      final status = _sspi.InitializeSecurityContextW(
        _credentials,
        _hasContext ? _context : nullptr,
        ''.toNativeUtf16(allocator: arena).cast(),
        ISC_REQ_ALLOCATE_MEMORY | ISC_REQ_CONFIDENTIALITY | ISC_REQ_REPLAY_DETECT | ISC_REQ_CONNECTION,
        0,
        SECURITY_NETWORK_DREP,
        challengeDesc,
        0,
        _context,
        tokenDesc,
        attrs,
        expiry,
      );

      print("InitializeSecurityContextW status $status");

      if (status == SEC_I_COMPLETE_AND_CONTINUE || status == SEC_I_CONTINUE_NEEDED) {
        _sspi.CompleteAuthToken(_context, tokenDesc);
      } else if (status != SEC_E_OK) {
        _sspi.FreeCredentialsHandle(_context);
        throw StateError("Status #2 $status");
      }
      _hasContext = true;

      final buffer = token.ref.pvBuffer.cast<Uint8>().asTypedList(token.ref.cbBuffer);
      final bytes = Uint8List(buffer.length);
      bytes.setAll(0, buffer);
      return bytes;
    });
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    if (_hasContext) {
      _sspi.FreeCredentialsHandle(_context);
    }
    calloc.free(_context);
  }
}

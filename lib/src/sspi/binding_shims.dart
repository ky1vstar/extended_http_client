import 'dart:ffi' as ffi;

class SecHandle extends ffi.Struct {
  @ffi.Uint64()
  external int dwLower;

  @ffi.Uint64()
  external int dwUpper;
}

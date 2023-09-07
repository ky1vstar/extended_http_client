import 'dart:ffi' as ffi;

base class SecHandle extends ffi.Struct {
  @ffi.Uint64()
  external int dwLower;

  @ffi.Uint64()
  external int dwUpper;
}

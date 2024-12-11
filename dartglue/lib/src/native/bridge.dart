// lib/src/native/bridge.dart
import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

// Native function type definitions
typedef CreateViewNative = ffi.Int64 Function(ffi.Int32);
typedef CreateViewDart = int Function(int);

typedef SetViewPropsNative = ffi.Void Function(
    ffi.Int64, ffi.Pointer<ffi.Void>);
typedef SetViewPropsDart = void Function(int, ffi.Pointer<ffi.Void>);

class NativeBridge {
  static final instance = NativeBridge._();
  static final _lib = _loadLibrary();

  NativeBridge._();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libdartglue.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    }
    throw UnsupportedError('Unsupported platform');
  }

  late final createView =
      _lib.lookupFunction<CreateViewNative, CreateViewDart>('createView');
  late final setViewProps =
      _lib.lookupFunction<SetViewPropsNative, SetViewPropsDart>('setViewProps');
}

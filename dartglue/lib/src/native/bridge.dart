import 'dart:ffi' as ffi;
import 'dart:io' show Platform;
import 'dart:convert' show jsonEncode;
import 'package:ffi/ffi.dart';
import '../core/components/view.dart';

typedef CreateViewNative = ffi.Int64 Function(ffi.Int32);
typedef CreateViewDart = int Function(int);
typedef SetViewPropsNative = ffi.Void Function(ffi.Int64, ffi.Pointer<ffi.Void>);
typedef SetViewPropsDart = void Function(int, ffi.Pointer<ffi.Void>);
typedef MountNative = ffi.Void Function(ffi.Int64);
typedef MountDart = void Function(int);

class Bridge {
  static final instance = Bridge._();
  static final _lib = _loadLibrary();
  
  Bridge._();

  static ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isAndroid) {
      return ffi.DynamicLibrary.open('libdartglue.so');
    } else if (Platform.isIOS) {
      return ffi.DynamicLibrary.process();
    }
    throw UnsupportedError('Unsupported platform');
  }

  late final createView = _lib.lookupFunction<CreateViewNative, CreateViewDart>('createView');
  
  late final setViewProps = _lib.lookupFunction<SetViewPropsNative, SetViewPropsDart>('setViewProps');
  
  late final _mount = _lib.lookupFunction<MountNative, MountDart>('mount');

  void updateViewProps(int handle, Map<String, dynamic> props) {
    final propsStr = jsonEncode(props);
    final nativeStr = propsStr.toNativeUtf8();
    setViewProps(handle, nativeStr.cast());
    malloc.free(nativeStr);
  }
// static int getHandle(View view) => view.nativeHandle;e

void mount(View root) {
    _mount(root.internalHandle);
  }


}
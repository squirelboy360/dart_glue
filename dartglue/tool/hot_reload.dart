import 'dart:io';
import 'dart:async';
import 'package:vm_service/vm_service.dart';
import 'package:vm_service/vm_service_io.dart';

class HotReloader {
  static VmService? _vmService;
  static String? _isolateId;

  static Future<void> startWatching() async {
    print('Starting hot reload watcher...');
    
    // Connect to VM service
    await _connectToVmService();
    
    var watcher = Directory('lib').watch(recursive: true);
    await for (var event in watcher) {
      if (event.type == FileSystemEvent.modify && 
          event.path.endsWith('.dart')) {
        await _reloadApp();
      }
    }
  }

  static Future<void> _connectToVmService() async {
    // Look for the VM service port in a file that Dart creates
    final serviceInfoFile = File('.dart_tool/vm_service_info.json');
    if (!await serviceInfoFile.exists()) {
      throw Exception('VM service info file not found. Are you running in debug mode?');
    }

    final serviceInfo = await serviceInfoFile.readAsString();
    final uri = Uri.parse(serviceInfo);
    
    // Connect to VM service
    _vmService = await vmServiceConnectUri(uri.toString());
    
    // Get the isolate ID
    final vm = await _vmService!.getVM();
    _isolateId = vm.isolates!.first.id;
  }

  static Future<void> _reloadApp() async {
    if (_vmService == null || _isolateId == null) {
      print('VM service not connected');
      return;
    }

    print('Reloading sources...');
    try {
      final response = await _vmService!.reloadSources(_isolateId!);
      if (response.success ?? false) {
        print('Hot reload complete');
      } else {
        print('Hot reload failed: ${response.toString()}');
      }
    } catch (e) {
      print('Hot reload error: $e');
    }
  }

  static void dispose() {
    _vmService?.dispose();
  }
}
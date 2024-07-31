import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flu_console_platform_interface.dart';

/// An implementation of [FluConsolePlatform] that uses method channels.
class MethodChannelFluConsole extends FluConsolePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flu_console');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}

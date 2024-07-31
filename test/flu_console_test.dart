import 'package:flutter_test/flutter_test.dart';
import 'package:flu_console/flu_console.dart';
import 'package:flu_console/flu_console_platform_interface.dart';
import 'package:flu_console/flu_console_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFluConsolePlatform 
    with MockPlatformInterfaceMixin
    implements FluConsolePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FluConsolePlatform initialPlatform = FluConsolePlatform.instance;

  test('$MethodChannelFluConsole is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFluConsole>());
  });

  test('getPlatformVersion', () async {
    FluConsole fluConsolePlugin = FluConsole();
    MockFluConsolePlatform fakePlatform = MockFluConsolePlatform();
    FluConsolePlatform.instance = fakePlatform;
  
    expect(await fluConsolePlugin.getPlatformVersion(), '42');
  });
}

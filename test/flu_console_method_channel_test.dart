import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flu_console/flu_console_method_channel.dart';

void main() {
  MethodChannelFluConsole platform = MethodChannelFluConsole();
  const MethodChannel channel = MethodChannel('flu_console');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}

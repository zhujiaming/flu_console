import 'dart:async';

import 'package:flu_console/src/eventbus.dart';
import 'package:flutter/foundation.dart';

export 'package:flu_console/src/panel.dart';

class FluConsole {
  static const int maxMessageLength = 50;

  getPlatformVersion() async {
    return '';
  }

  static List<String> _messages = [];

  static get messages => _messages;

  static void clearMessages() {
    _messages.clear();
  }

  static void run<T>(
    T Function() callback,
  ) {
    _messages = [];
    runZonedGuarded(() {
      callback();
    }, (error, stackTrace) {
      if (kDebugMode) {
        print('start print error stackTrace');
        print(error);
        print(stackTrace);
      }
    }, zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
      if (kDebugMode) {
        parent.print(zone, "wrapped content=$message");
        _addMessage(message);
      }
    }));
  }

  static EventBus? eventBus;

  static void _addMessage(String message) {
    var length = _messages.length;
    if (length == maxMessageLength) {
      _messages.removeAt(0);
    }
    String wrap = '${DateTime.now().toString()}:$message';
    _messages.add(wrap);
    eventBus?.fire(wrap);
  }
}

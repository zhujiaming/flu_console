import 'dart:async';

import 'package:flu_console/src/eventbus.dart';
import 'package:flu_console/src/message.dart';
import 'package:flutter/foundation.dart';

export 'package:flu_console/src/panel.dart';

class FluConsole {
  static const int maxMessageLength = 50;

  getPlatformVersion() async {
    return '';
  }

  static List<Message> _messages = [];

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
        _addMessage(Message(
            content: '${error.toString()}\n${stackTrace.toString()}',
            messageType: MessageType.error,time: DateTime.now()));
      }
    }, zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
      if (kDebugMode) {
        parent.print(zone, "wrapped content=$message");
        _addMessage(Message(content: message,time: DateTime.now()));
      }
    }));
  }

  static EventBus? eventBus;

  static void _addMessage(Message message) {
    var length = _messages.length;
    if (length == maxMessageLength) {
      _messages.removeAt(0);
    }
    // String wrap = message.content;
    // wrap = '${DateTime.now().toString()}:$message';
    _messages.add(message);
    eventBus?.fire('');
  }
}

import 'dart:async';

import 'package:flu_console/src/eventbus.dart';
import 'package:flu_console/src/message.dart';
import 'package:flu_console/src/overlay_console_widget.dart';
import 'package:flu_console/src/res.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

export 'package:flu_console/src/panel.dart';

class FluConsole {
  static const int maxMessageLength = 50;

  static OverlayEntry? itemEntry;

  getPlatformVersion() async {
    return '';
  }

  static List<Message> _messages = [];

  static List<Message> empty = [Message(content: "empty")];

  static get messages => _messages;

  static void clearMessages() {
    _messages.clear();
  }

  static void run<T>(T Function() callback, {bool enableLog = kDebugMode}) {
    _messages = [];
    runZonedGuarded(() {
      callback();
    }, (error, stackTrace) {
      if (enableLog) {
        print('start print error stackTrace');
        print(error);
        print(stackTrace);
        _addMessage(Message(content: '${error.toString()}\n${stackTrace.toString()}', messageType: MessageType.error, time: DateTime.now()));
      }
    }, zoneSpecification: ZoneSpecification(print: (Zone self, ZoneDelegate parent, Zone zone, String message) {
      if (enableLog) {
        parent.print(zone, message);
        _addMessage(Message(content: message, time: DateTime.now()));
      }
    }));
  }

  static dismissConsoleButton() {
    itemEntry?.remove();
    itemEntry = null;
  }

  static showConsoleButton(BuildContext context) {
    dismissConsoleButton();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    // print("show debug button run");
    itemEntry = OverlayEntry(builder: (BuildContext context) => const OverlayConsoleWidget());
    if (itemEntry != null) {
      Overlay.of(context).insert(itemEntry!);
    }
    // });
  }

  static bool isShowConsoleButton() {
    return itemEntry != null;
  }

  static showToast(BuildContext context, String message, {Duration duration = const Duration(seconds: 2)}) {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: MediaQuery.of(context).size.height * 0.8,
        child: Container(
          color: Colors.transparent,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Res.colorBarBg,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(message),
                ),
              )
            ],
          ),
        ),
      );
    });
    Overlay.of(context).insert(overlayEntry);
    Future.delayed(duration).then((value) {
      overlayEntry.remove();
    });
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

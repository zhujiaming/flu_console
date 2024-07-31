import 'dart:async';

import 'package:flu_console/flu_console.dart';
import 'package:flu_console/src/eventbus.dart';
import 'package:flu_console/src/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'message.dart';

class LogPrintPanel extends StatefulWidget {
  const LogPrintPanel({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LogPrintPanelState();
  }
}

class LogPrintPanelState extends State<LogPrintPanel> {
  final ScrollController _listController = ScrollController();

  final _filterController = TextEditingController();

  Color pageBg = Colors.transparent;

  void printLog(String log) {}

  void _clearPress() {
    FluConsole.clearMessages();
    setState(() {});
  }

  void _hidePress() {
    Navigator.pop(context);
  }

  void _filterPress() {}

  List<Message> getLogList() {
    return FluConsole.messages.length == 0
        ? FluConsole.empty
        : FluConsole.messages;
  }

  @override
  void initState() {
    super.initState();
    FluConsole.eventBus = EventBus();
    FluConsole.eventBus!.on<String>().listen((event) {
      setState(() {});
    });
    Timer(
        const Duration(milliseconds: 600),
        () => {
              setState(() {
                pageBg = Colors.black45;
              })
            });
  }

  void _postScrollToBottom() {
    Future.delayed(const Duration(milliseconds: 10), () {
      _listController.jumpTo(_listController.position.maxScrollExtent);
    });
  }

  @override
  void dispose() {
    FluConsole.eventBus?.destroy();
    FluConsole.eventBus = null;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LogPrintPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget run");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("didChangeDependencies run");
  }

  @override
  Widget build(BuildContext context) {
    var stateBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: null,
      backgroundColor: pageBg,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => {_hidePress()},
            child: Container(
              width: double.infinity,
              height: 100,
              color: Colors.transparent,
            ),
          ),
          Expanded(
              child: Container(
            color: Res.colorBg,
            child: Column(
              children: [
                // Container(
                //   color: Res.colorBg,
                //   height: 30,
                //   margin: EdgeInsets.only(top: stateBarHeight),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.start,
                //     children: [
                //       Expanded(
                //         child: TextField(
                //           controller: _filterController,
                //           style: const TextStyle(fontSize: 13),
                //           decoration: const InputDecoration(
                //             contentPadding: EdgeInsets.only(left: 10.0),
                //             border: InputBorder.none,
                //             isDense: true,
                //             hintText: "input filter",
                //             hintStyle: TextStyle(fontSize: 13),
                //           ),
                //           autofocus: false,
                //           onChanged: (v) {
                //             _doFilter(v);
                //           },
                //         ),
                //       ),
                //       if (_filterController.text.isNotEmpty)
                //         GestureDetector(
                //           onTap: () {
                //             _filterController.text = '';
                //             setState(() {});
                //           },
                //           child: const Icon(
                //             Icons.cancel,
                //             color: Colors.grey,
                //             size: 20,
                //           ),
                //         )
                //     ],
                //   ),

                // ),
                Expanded(
                    child: MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 50),
                          controller: _listController,
                          itemBuilder: (ctx, i) {
                            // _postScrollToBottom();
                            return _buildItem(ctx, i);
                          },
                          itemCount: getLogList().length,
                        ))),
                Container(
                  height: 40,
                  color: Res.colorBarBg,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // MaterialButton(
                        //   onPressed: _filterPress,
                        //   child: const Text("Filter"),
                        // ),
                        // Container(
                        //   width: 1,
                        //   height: 30,
                        //   margin: const EdgeInsets.symmetric(vertical: 2),
                        //   color: Res.colorFont2,
                        // ),
                        MaterialButton(
                          onPressed: _clearPress,
                          child: const Text("Clear"),
                        ),
                        Container(
                          width: 1,
                          height: 30,
                          margin: const EdgeInsets.symmetric(vertical: 2),
                          color: Res.colorFont2,
                        ),
                        MaterialButton(
                          onPressed: _hidePress,
                          child: const Text('Hide'),
                        ),
                      ]),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext ctx, int i) {
    Message message = getLogList()[i];
    String logInfo = message.content;
    String time = '';
    if (message.time != null) {
      final int millSec = message.time!.millisecond;
      final String millSecStr = millSec < 100 ? "0$millSec" : "$millSec";
      time =
          '${message.time?.hour}:${message.time?.minute}:${message.time?.second}:$millSecStr';
    }

    bool isError = message.messageType == MessageType.error;
    return Container(
      width: double.infinity,
      color: Res.colorBg,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(left: 6, right: 10, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$time:',
                        style:
                            const TextStyle(fontSize: 8, color: Res.colorFont2),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                      style: TextStyle(
                          fontSize: 13,
                          color: isError ? Colors.redAccent : Res.colorFont1),
                      controller: TextEditingController(
                        text: logInfo,
                      ),
                      readOnly: true,
                      maxLines: null,
                      decoration: null),
                ),
                GestureDetector(
                  child: const Icon(
                    Icons.copy,
                    color: Colors.black12,
                    size: 15,
                  ),
                  onTap: () {
                    FluConsole.showToast(context, "Copied");
                    Clipboard.setData(ClipboardData(text: '$time:$logInfo'));
                  },
                )
              ],
            ),
          ),
          Container(
            height: 0.5,
            width: double.infinity,
            color: Colors.black12,
          )
        ],
      ),
    );
  }

  void _doFilter(String v) {
    // print('input $v');
  }

  void _doCopy() {}
}

class PageNavAnimBuilder extends PageRouteBuilder {
  final Widget widget;

  PageNavAnimBuilder(this.widget)
      : super(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation1,
                Animation<double> animation2,
                Widget child) {
              return SlideTransition(
                position: Tween<Offset>(
                        begin: const Offset(0.0, 1.0),
                        end: const Offset(0.0, 0.0))
                    .animate(CurvedAnimation(
                        parent: animation1, curve: Curves.fastOutSlowIn)),
                child: child,
              );
            },
            opaque: false);
}

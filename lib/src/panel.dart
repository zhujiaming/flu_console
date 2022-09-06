import 'package:flu_console/flu_console.dart';
import 'package:flu_console/src/eventbus.dart';
import 'package:flutter/material.dart';

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

  void printLog(String log) {}

  void _clearPress() {
    FluConsole.clearMessages();
    setState(() {});
  }

  void _hidePress() {
    Navigator.pop(context);
  }

  List<Message> getLogList() {
    return FluConsole.messages;
  }

  @override
  void initState() {
    super.initState();
    FluConsole.eventBus = EventBus();
    FluConsole.eventBus!.on<String>().listen((event) {
      setState(() {});
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
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    print("didUpdateWidget run");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    print("didChangeDependencies run");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Column(
        children: [
          Container(
            color: const Color(0xffEDEDED),
            height: 30,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    child: TextField(
                  controller: _filterController,
                  style: TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 10.0),
                    border: InputBorder.none,
                    isDense: true,
                    hintText: "input filter",
                    hintStyle: TextStyle(fontSize: 13),
                  ),
                  autofocus: false,
                )),
                if (_filterController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _filterController.text = '';
                      setState(() {});
                    },
                    child: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
              ],
            ),
          ),
          Expanded(
              child: ListView.builder(
            controller: _listController,
            itemBuilder: (ctx, i) {
              // _postScrollToBottom();
              return _buildItem(ctx, i);
            },
            itemCount: getLogList().length,
          )),
          Container(
            height: 40,
            color: const Color(0xffEDEDED),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    onPressed: _clearPress,
                    child: Text("Clear"),
                  ),
                  Container(
                    width: 1,
                    height: 30,
                    margin: EdgeInsets.symmetric(vertical: 2),
                    color: Color(0xff000000),
                  ),
                  MaterialButton(
                    onPressed: _hidePress,
                    child: Text('Hide'),
                  ),
                ]),
          )
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext ctx, int i) {
    Message message = getLogList()[i];
    String logInfo = message.content;
    String time =
        '${message.time?.hour}:${message.time?.minute}:${message.time?.second}:${message.time?.millisecond}';
    bool isError = message.messageType == MessageType.error;
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 6, right: 10, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$time:',
                        style: TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TextField(
                      style: TextStyle(
                          fontSize: 13,
                          color:
                              isError ? Colors.redAccent : Color(0xff191919)),
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
                    color: Color(0xffb2b2b2),
                    size: 15,
                  ),
                  onTap: () {
                    print('copy content:${logInfo}');
                  },
                )
              ],
            ),
          ),
          Container(
            height: 1,
            width: double.infinity,
            color: Color(0xffE5E5E5),
          )
        ],
      ),
    );
  }
}

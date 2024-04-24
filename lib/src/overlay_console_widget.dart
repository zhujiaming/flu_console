import 'package:flutter/material.dart';

import '../flu_console.dart';

class OverlayConsoleWidget extends StatefulWidget {
  const OverlayConsoleWidget({Key? key}) : super(key: key);

  // double btnSize = 100;

  @override
  State<StatefulWidget> createState() {
    return OverlayConsoleWidgetState();
  }
}

class OverlayConsoleWidgetState extends State<OverlayConsoleWidget> {
  double left = 30;
  double top = 100;
  double screenWidth = 0;
  double screenHeight = 0;

  double btnWidth = 60;
  double btnHeight = 30;

  bool visible = true;

  void onClick() async {
    setState(() {
      visible = false;
    });
    await Navigator.of(context).push(
        PageNavAnimBuilder(const LogPrintPanel())
    );
    setState(() {
      visible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    // screenWidth = MediaQuery.of(context).size.width;
    // screenHeight = MediaQuery.of(context).size.height;

    left = screenWidth - btnWidth;
    top = screenHeight - btnHeight;
  }

  @override
  Widget build(BuildContext context) {
    if(screenWidth == 0) {
      screenWidth = MediaQuery.of(context).size.width;
      screenHeight = MediaQuery.of(context).size.height;
      left = screenWidth - btnWidth;
      top = screenHeight - btnHeight;
    }

    Widget w;
    Color primaryColor = Colors.redAccent;
    primaryColor = primaryColor.withOpacity(0.6);
    w = GestureDetector(
      onTap: onClick,
      onPanUpdate: _dragUpdate,
      child: Container(
        width: btnWidth,
        height: btnHeight,
        color: primaryColor,
        child: const Center(
          child: Text(
            "log",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.normal,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );

    ///计算偏移量限制
    if (left < 1) {
      left = 1;
    }
    if (left > screenWidth - btnWidth) {
      left = screenWidth - btnWidth;
    }

    if (top < 1) {
      top = 1;
    }
    if (top > screenHeight - btnHeight) {
      top = screenHeight - btnHeight;
    }
    w = Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: left, top: top),
      child: w,
    );
    return Visibility(
      visible: visible,
      child: w,
    );
  }

  _dragUpdate(DragUpdateDetails detail) {

    Offset offset = detail.delta;
    left = left + offset.dx;
    top = top + offset.dy;
    setState(() {});
  }
}

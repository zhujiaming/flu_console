import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flu_console/flu_console.dart';

void main() {
  FluConsole.run(() {
    runApp(const App());
  });
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyAppState();
}

class _MyAppState extends State<HomePage> {
  int count = 0;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      print("${(count++)}");
      if (count == 20) {
        timer.cancel();
        throw Exception('test error');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Stack(
          children: [
            Center(
              child: GestureDetector(
                child: const Text(''),
              ),
            ),
            Column(
              children: [
                LayoutBuilder(builder: (ctx, constraints) {
                  return Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          FluConsole.showConsoleButton(context);
                        },
                        child: const Text("show log button"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(ctx)
                              .push(PageNavAnimBuilder(const LogPrintPanel()));
                        },
                        child: const Text("open log"),
                      )
                    ],
                  );
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}

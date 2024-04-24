# flu_console

Display the flutter log on the app

## Getting Started

    - step 1
```dart

    FluConsole.run(() {
        runApp(const App());
    });

    //or

    FluConsole.run(() {
        runApp(const App());
    },enableLog: true);
```
    - step 2
```dart
   
    FluConsole.showConsoleButton(context);
    // or 
    Navigator.of(ctx).push(PageNavAnimBuilder(const LogPrintPanel()));
```

## ScreenShot

<img src="./image/temp.png" width="210px">


# flu_console

Display the flutter log on the app

## Getting Started

```dart
    // step 1
    FluConsole.run(() {
        runApp(const App());
    });

    // step 2
    FluConsole.showConsoleButton(context);
    // or 
    Navigator.of(ctx).push(PageNavAnimBuilder(const LogPrintPanel()));
```


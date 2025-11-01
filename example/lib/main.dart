import 'package:flutter/material.dart';
import 'package:hz_toast/hz_toast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      builder: (context, child) {
        return Material(
          child: Overlay(
            initialEntries: [
              OverlayEntry(builder: (context) => child!),

              //add toast overlay entry
              OverlayEntry(builder: (context) => HzToastWidget()), // <-- HzToastWidget
            ],
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });

    HzToast.show(HzToastData(
      'Button pressed $_counter times',
      type: HzToastType.success,
    ));
  }

  void _showErrorToast() {
    HzToast.show(HzToastData(
      'An error occurred!',
      type: HzToastType.error,
    ));
  }

  void _showWarningToast() {
    HzToast.show(HzToastData(
      'This is a warning!',
      type: HzToastType.warning,
    ));
  }

  void _showInfoToast() {
    HzToast.show(HzToastData(
      'Some informational message.',
      type: HzToastType.info,
    ));
  }

  void _withProgressToast() {
    HzToast.show(HzToastData(
      'This is toast message',
      type: HzToastType.info,
      duration: Duration(seconds: 5),
      showProgressBar: true,
    ));
  }

  void _withProgressToast2() async {
    final id = UniqueKey().toString();
    ValueNotifier<int> progress = ValueNotifier<int>(0);
    final result = HzToast.show(HzToastData(
      'Processing...',
      id: id,
      type: HzToastType.info,
      autoHide: false,
      clickable: false,
      showCloseIcon: false,
      titleBuilder: (title, color) {
        return ValueListenableBuilder<int>(
          valueListenable: progress,
          builder: (context, value, child) {
            return Text(
              '$title (${value.toStringAsFixed(0)}%)',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: color,
              ),
            );
          },
        );
      },
    ));

    if (result) {
      for (int i = 1; i <= 100; i++) {
        await Future.delayed(const Duration(milliseconds: 80));
        progress.value = i;
      }
      HzToast.update(id, HzToastData('Completed!', type: HzToastType.success));
      HzToast.hideIn(id, const Duration(seconds: 1));
    }
    progress.dispose();
  }

  void _randomStyledToast() {
    HzToast.show(HzToastData(
      'Random styled toast',
      backgroundColor: Colors.purple,
      textColor: Colors.yellow,
      iconColor: Colors.yellow,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(right: 8, bottom: 16),
      borderRadius: BorderRadius.circular(16),
      titleBuilder: (title, color) {
        return Text.rich(TextSpan(
          text: '🔥 ',
          children: [
            TextSpan(
              text: title,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const TextSpan(
              text: ' 🔥',
            ),
          ],
        ));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Increment Counter and Show Success Toast'),
            ),

            // Buttons to show different toasts
            ElevatedButton(
              onPressed: _showErrorToast,
              child: const Text('Show Error Toast'),
            ),
            ElevatedButton(
              onPressed: _showWarningToast,
              child: const Text('Show Warning Toast'),
            ),
            ElevatedButton(
              onPressed: _showInfoToast,
              child: const Text('Show Info Toast'),
            ),
            ElevatedButton(
              onPressed: _withProgressToast,
              child: const Text('Show Toast with Progress Bar'),
            ),
            ElevatedButton(
              onPressed: _withProgressToast2,
              child: const Text('Show Toast with Dynamic Progress'),
            ),
            ElevatedButton(
              onPressed: _randomStyledToast,
              child: const Text('Show Random Styled Toast'),
            ),
          ],
        ),
      ),
    );
  }
}

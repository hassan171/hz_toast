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

              // Single toast widget that handles all alignments automatically
              OverlayEntry(builder: (context) => const HzToastWidget()),
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
  int _alignmentCounter = 0;

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

  // Alignment Examples
  void _showTopRightToast() {
    setState(() => _alignmentCounter++);
    HzToast.show(HzToastData(
      'Top Right Toast #$_alignmentCounter',
      type: HzToastType.info,
      alignment: HzToastAlignment.topRight,
      backgroundColor: Colors.blue.shade50,
      textColor: Colors.blue.shade800,
      iconColor: Colors.blue,
    ));
  }

  void _showTopLeftToast() {
    setState(() => _alignmentCounter++);
    HzToast.show(HzToastData(
      'Top Left Toast #$_alignmentCounter',
      type: HzToastType.success,
      alignment: HzToastAlignment.topLeft,
      backgroundColor: Colors.green.shade50,
      textColor: Colors.green.shade800,
      iconColor: Colors.green,
    ));
  }

  void _showBottomRightToast() {
    setState(() => _alignmentCounter++);
    HzToast.show(HzToastData(
      'Bottom Right Toast #$_alignmentCounter',
      type: HzToastType.warning,
      alignment: HzToastAlignment.bottomRight,
      backgroundColor: Colors.orange.shade50,
      textColor: Colors.orange.shade800,
      iconColor: Colors.orange,
    ));
  }

  void _showBottomLeftToast() {
    setState(() => _alignmentCounter++);
    HzToast.show(HzToastData(
      'Bottom Left Toast #$_alignmentCounter',
      type: HzToastType.error,
      alignment: HzToastAlignment.bottomLeft,
      backgroundColor: Colors.red.shade50,
      textColor: Colors.red.shade800,
      iconColor: Colors.red,
    ));
  }

  void _showAllAlignments() {
    setState(() => _alignmentCounter++);

    HzToast.show(HzToastData(
      'Top Right #$_alignmentCounter',
      type: HzToastType.info,
      alignment: HzToastAlignment.topRight,
      duration: const Duration(seconds: 6),
    ));

    HzToast.show(HzToastData(
      'Top Left #$_alignmentCounter',
      type: HzToastType.success,
      alignment: HzToastAlignment.topLeft,
      duration: const Duration(seconds: 6),
    ));

    HzToast.show(HzToastData(
      'Bottom Right #$_alignmentCounter',
      type: HzToastType.warning,
      alignment: HzToastAlignment.bottomRight,
      duration: const Duration(seconds: 6),
    ));

    HzToast.show(HzToastData(
      'Bottom Left #$_alignmentCounter',
      type: HzToastType.error,
      alignment: HzToastAlignment.bottomLeft,
      duration: const Duration(seconds: 6),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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

                const Divider(height: 32),
                const Text(
                  'Basic Toast Types',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                const Divider(height: 32),
                const Text(
                  'Toast Alignment Examples',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showTopLeftToast,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade100,
                          foregroundColor: Colors.green.shade800,
                        ),
                        child: const Text('Top Left'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showTopRightToast,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade100,
                          foregroundColor: Colors.blue.shade800,
                        ),
                        child: const Text('Top Right'),
                      ),
                    ),
                  ],
                ),

                Row(
                  spacing: 8,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showBottomLeftToast,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade800,
                        ),
                        child: const Text('Bottom Left'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _showBottomRightToast,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade100,
                          foregroundColor: Colors.orange.shade800,
                        ),
                        child: const Text('Bottom Right'),
                      ),
                    ),
                  ],
                ),

                ElevatedButton.icon(
                  onPressed: _showAllAlignments,
                  icon: const Icon(Icons.grid_view),
                  label: const Text('Show All Alignments'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade100,
                    foregroundColor: Colors.purple.shade800,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),

                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => HzToast.hideAll(),
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Hide All Toasts'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: Colors.grey.shade800,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

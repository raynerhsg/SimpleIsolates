import 'dart:isolate';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Isolates Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Isolates'),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset('assets/gifs/sapo-dance.gif'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                final total = _withoutIsolates();
                debugPrint(total.toString());
              },
              child: const Text('Without Isolates'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _withIsolates();
              },
              child: const Text('With Isolates'),
            ),
          ],
        ),
      ),
    );
  }

  _withIsolates() {
    final port = ReceivePort();
    Isolate.spawn(forFuntion, port.sendPort);
    port.listen((message) {
      debugPrint('Received: $message');
    });
  }

  int _withoutIsolates() {
    int total = 0;

    for (var i = 0; i < 1000000000; i++) {
      total += i;
    }
    return total;
  }
}

forFuntion(SendPort sendPort) {
  int total = 0;

  for (var i = 0; i < 1000000000; i++) {
    total += i;
  }
  sendPort.send(total);
}

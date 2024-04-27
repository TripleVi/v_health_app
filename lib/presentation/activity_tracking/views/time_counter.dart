import 'dart:async';

import 'package:flutter/material.dart';

class TimeCounter extends StatefulWidget {
  final Stream<int> timeStream;
  final Widget Function(int secondsElapsed) builder;
  
  const TimeCounter({super.key, required this.builder, required this.timeStream});

  @override
  State<TimeCounter> createState() => _TimeCounterState();
}

class _TimeCounterState extends State<TimeCounter> {
  StreamSubscription<int>? _secondSubscription;
  int _secondsElapsed = 0;

  @override
  void initState() {
    super.initState();
    _secondSubscription = widget.timeStream.listen((event) {
      setState(() {
        _secondsElapsed = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(_secondsElapsed);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
    await _secondSubscription?.cancel();
  }
}
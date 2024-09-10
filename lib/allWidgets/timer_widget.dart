import 'dart:async'; // Import Timer class
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final bool initTimerNow;

  TimerWidget({super.key, required this.initTimerNow});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Duration duration = Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Start or stop the timer based on the initial value of `initTimerNow`
    if (widget.initTimerNow) {
      startTimerNow();
    }
  }

  @override
  void didUpdateWidget(TimerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Start or stop the timer when the value of `initTimerNow` changes
    if (widget.initTimerNow != oldWidget.initTimerNow) {
      if (widget.initTimerNow) {
        startTimerNow();
      } else {
        stopTimerNow();
      }
    }
  }

  // Start the timer
  void startTimerNow() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          duration = Duration(seconds: duration.inSeconds + 1);
        });
      }
    });
  }

  // Stop and reset the timer
  void stopTimerNow() {
    setState(() {
      timer?.cancel();
      timer = null;
      duration = Duration();
    });
  }

  // Helper function to format numbers with two digits
  String twoDigit(int number) => number.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final minutes = twoDigit(duration.inMinutes.remainder(60));
    final seconds = twoDigit(duration.inSeconds.remainder(60));
    final hours = twoDigit(
        duration.inHours.remainder(24)); // Use 24 instead of 60 for hours

    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(
        fontSize: 23,
      ),
    );
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }
}

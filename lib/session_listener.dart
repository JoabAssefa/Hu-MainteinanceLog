import 'dart:async';

import 'package:flutter/material.dart';

class SessionTimeOutListener extends StatefulWidget {
  Widget child;
  Duration duration;
  VoidCallback onTimeOut;
  SessionTimeOutListener(
      {super.key,
      required this.child,
      required this.duration,
      required this.onTimeOut});

  @override
  State<SessionTimeOutListener> createState() => _SessionTimeOutListenerState();
}

class _SessionTimeOutListenerState extends State<SessionTimeOutListener> {
  Timer? _timer;
  _startTimer() {
    print('Timer reset');
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    _timer = Timer(widget.duration, () {
      print("Elapsed");
      widget.onTimeOut();
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer?.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) {
        _startTimer();
      },
      child: widget.child,
    );
  }
}

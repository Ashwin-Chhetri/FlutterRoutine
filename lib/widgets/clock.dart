import 'dart:async';
import 'package:flutter/material.dart';
import 'package:minaroutine/setting/apptheme.dart';

class ClockWidget extends StatefulWidget {
  const ClockWidget({super.key});

  @override
  State<ClockWidget> createState() => _ClockWidgetState();
}

class _ClockWidgetState extends State<ClockWidget> {
  DateTime _dateTime = DateTime.now();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    if (mounted) {
      setState(() {
        _dateTime = DateTime.now();
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.13,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${_dateTime.hour.toString().padLeft(2, '0')}:${_dateTime.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(
                  fontSize: 72, color: AppTheme.lightPrimary, fontFamily: 'DS-DIGITAL'),
            ),
          ],
        ),
      ),
    );
  }
}

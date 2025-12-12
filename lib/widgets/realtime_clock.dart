import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RealtimeClock extends StatefulWidget {
  const RealtimeClock({super.key});

  @override
  State<RealtimeClock> createState() => _RealtimeClockState();
}

class _RealtimeClockState extends State<RealtimeClock> {
  String _dateString = "";
  String _timeString = "";
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    // Timer hanya hidup di dalam widget kecil ini
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer t) => _updateTime(),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    if (mounted) {
      final DateTime now = DateTime.now();
      setState(() {
        _dateString = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now);
        _timeString = DateFormat('HH:mm:ss').format(now);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _dateString,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          _timeString,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w300,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

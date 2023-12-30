import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:minaroutine/setting/setting.dart';

class WeekDays extends StatefulWidget {
  const WeekDays({super.key});

  @override
  State<WeekDays> createState() => _WeekDaysState();
}

class _WeekDaysState extends State<WeekDays> {
  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(days: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    setState(() {
      _dateTime = DateTime.now();
    });
  }

  Widget getWeekDay(String weekDay, {double fontSize = 12}) {
    return Text(
      weekDay,
      style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w600),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getWeekDay(DateFormat('EE').format(_dateTime.subtract(const Duration(days: 3)))),
                  getWeekDay(DateFormat('EE').format(_dateTime.subtract(const Duration(days: 2)))),
                  getWeekDay(DateFormat('EE').format(_dateTime.subtract(const Duration(days: 1)))),
                ],
              ),
            ),
            getWeekDay(DateFormat('EEEE').format(_dateTime), fontSize: 24),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  getWeekDay(DateFormat('EE').format(_dateTime.add(const Duration(days: 1)))),
                  getWeekDay(DateFormat('EE').format(_dateTime.add(const Duration(days: 2)))),
                  getWeekDay(DateFormat('EE').format(_dateTime.add(const Duration(days: 3)))),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 3,
                decoration: const BoxDecoration(
                  color: AppTheme.lightPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.07,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppTheme.lightPrimary,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  _dateTime.day.toString(),
                  style: const TextStyle(color: AppTheme.lightOnPrimary),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                height: 3,
                decoration: const BoxDecoration(
                  color: AppTheme.lightPrimary,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          //color: Colors.purple,
          width: 100,
          height: 40,
          alignment: Alignment.center,
          child: Text(
            DateFormat('MMM').format(DateTime.now()),
            style: const TextStyle(
                color: AppTheme.lightPrimary,
                fontSize: 20,
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

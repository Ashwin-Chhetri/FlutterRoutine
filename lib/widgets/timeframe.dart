import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:minaroutine/setting/setting.dart';

class TimeFrame extends StatefulWidget {
  const TimeFrame({Key? key}) : super(key: key);

  @override
  State<TimeFrame> createState() => TimeFrameState();
}

class TimeFrameState extends State<TimeFrame> {
  final _startTimeController = TextEditingController();
  final _endTimeController = TextEditingController();
  final FocusNode _startTimeFocus = FocusNode();
  final FocusNode _endTimeFocus = FocusNode();

  final Map<String, DateTime> timeGap = {
    "30 min": DateTime.utc(2023, 1, 1, 0, 30),
    "1 hr": DateTime.utc(2023, 1, 1, 1, 00),
    "1:30 hr": DateTime.utc(2023, 1, 1, 1, 30),
    "2 hr": DateTime.utc(2023, 1, 1, 2, 00),
    "2:30 hr": DateTime.utc(2023, 1, 1, 2, 30),
    "3 hr": DateTime.utc(2023, 1, 1, 3, 00),
    "3:30 hr": DateTime.utc(2023, 1, 1, 3, 30),
    "4 hr": DateTime.utc(2023, 1, 1, 4, 00)
  };
  int timeGapIndex = 0;
  //{To Do}
  void setEndTime(String startTime, String timeframe) {
    final dateTime = DateFormat('h:mm a').parse(startTime);
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final DateTime startTimeUTC = DateTime.utc(2023, 1, 1, hour, minute);
    final DateTime gap = timeGap[timeframe]!;
    final DateTime endTimeUTC = startTimeUTC.add(Duration(hours: gap.hour, minutes: gap.minute));
    setState(() {
      _endTimeController.text = DateFormat('hh:mm a').format(endTimeUTC);
    });
  }

  // UnderLine Container border property
  double _underLineContainerWidth = 1.5;
  Color _underLineContainerColor = AppTheme.lightPrimary.withOpacity(0.7);

  // Show error message
  bool visibleErrorMsg = false;
  String errorMsg = 'Please enter your time';

  @override
  void initState() {
    super.initState();
    _startTimeFocus.addListener(() {
      hasFocus();
    });
    _endTimeFocus.addListener(() {
      hasFocus();
    });
  }

  // Update the UnderLine Container when TextField has focus
  void hasFocus() {
    if (!visibleErrorMsg) {
      if (_startTimeFocus.hasFocus || _endTimeFocus.hasFocus) {
        setState(() {
          _underLineContainerWidth = 2;
          _underLineContainerColor = AppTheme.lightPrimary;
        });
      } else {
        setState(() {
          _underLineContainerWidth = 1;
          _underLineContainerColor = AppTheme.lightPrimary.withOpacity(0.7);
        });
      }
    }
  }

  void toggleErrorState(String error, bool isError) {
    if (isError) {
      setState(() {
        visibleErrorMsg = isError;
        errorMsg = error;
        _underLineContainerWidth = 2;
        _underLineContainerColor = Colors.red;
      });
    } else {
      setState(() {
        visibleErrorMsg = isError;
        _underLineContainerWidth = 1;
        _underLineContainerColor = AppTheme.lightPrimary.withOpacity(0.7);
      });
    }
  }

  List<String> validateTime() {
    if (DateTimeHelper.validateTime(_startTimeController.text) &&
        DateTimeHelper.validateTime(_endTimeController.text)) {
      toggleErrorState("", false);
      return [_startTimeController.text, _endTimeController.text];
    } else {
      toggleErrorState("Please Enter time in hh:mm AM/PM format. e.g. 06:00 AM", true);
      return ['', ''];
    }
  }

  @override
  void dispose() {
    _startTimeFocus.dispose();
    _endTimeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
                height: 30,
                child: Icon(
                  Icons.timer_sharp,
                  size: 30,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                height: 50,
                padding: const EdgeInsets.only(top: 7, bottom: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 100,
                      child: TextField(
                        focusNode: _startTimeFocus,
                        controller: _startTimeController,
                        textInputAction: TextInputAction.next,
                        style: AppTheme.bodyTextStyle,
                        textAlignVertical: TextAlignVertical.center,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [TimeInputFormatter()],
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          filled: true,
                          labelStyle: AppTheme.labelStyle,
                          fillColor: Colors.grey.withOpacity(0.4),
                        ),
                        onEditingComplete: () {
                          //call the function to add the time frame automatically
                          if (DateTimeHelper.validateTime(_startTimeController.text)) {
                            setEndTime(
                                _startTimeController.text, timeGap.keys.toList()[timeGapIndex]);
                          }
                        },
                      ),
                    ),
                    const Text(" - ", style: AppTheme.bodyTextStyle),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        focusNode: _endTimeFocus,
                        controller: _endTimeController,
                        textAlign: TextAlign.center,
                        style: AppTheme.bodyTextStyle,
                        textAlignVertical: TextAlignVertical.center,
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [TimeInputFormatter()],
                        decoration: InputDecoration(
                          labelStyle: AppTheme.labelStyle,
                          filled: true,
                          isDense: true,
                          contentPadding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          fillColor: Colors.grey.withOpacity(0.4),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: SizedBox(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_left),
                        onPressed: () {
                          setState(() {
                            if (timeGapIndex > 0) {
                              timeGapIndex = timeGapIndex - 1;
                            }
                          });
                          //call the function to add the time frame automatically
                          setEndTime(
                              _startTimeController.text, timeGap.keys.toList()[timeGapIndex]);
                        },
                      ),
                    ),
                    Expanded(
                      child: Text(
                        timeGap.keys.toList()[timeGapIndex],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            if (timeGapIndex < 7) {
                              timeGapIndex = timeGapIndex + 1;
                            }
                          });
                          //call the function to add the time frame automatically
                          setEndTime(
                              _startTimeController.text, timeGap.keys.toList()[timeGapIndex]);
                        },
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        Container(
          decoration: ShapeDecoration(
            shape: UnderlineInputBorder(
              borderSide: BorderSide(
                width: _underLineContainerWidth,
                color: _underLineContainerColor,
              ),
            ),
          ),
        ),
        Visibility(
            visible: visibleErrorMsg,
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                errorMsg,
                style: AppTheme.errorStyle,
              ),
            ))
      ],
    );
  }
}

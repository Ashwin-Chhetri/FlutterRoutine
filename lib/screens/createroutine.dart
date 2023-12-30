import 'package:flutter/material.dart';
import 'package:minaroutine/data/routinedata.dart';
import 'package:minaroutine/model/routine.dart';
import 'package:minaroutine/provider/routine_provider.dart';
import 'package:minaroutine/setting/setting.dart';
import 'package:minaroutine/widgets/timeframe.dart';
import 'package:provider/provider.dart';

class CreateRoutine extends StatefulWidget {
  const CreateRoutine({super.key});

  @override
  State<CreateRoutine> createState() => _CreateRoutineState();
}

class _CreateRoutineState extends State<CreateRoutine> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<TimeFrameState> _timeFrameKey = GlobalKey<TimeFrameState>();
  late RoutineProvider routineProvider;

  final _routineNameController = TextEditingController();
  final _objectiveController = TextEditingController();
  late String startTime, endTime;

  @override
  void dispose() {
    _routineNameController.dispose();
    super.dispose();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  void _handleSubmitted() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      //Run validate time
      List<String> timeframe = _timeFrameKey.currentState!.validateTime();
      // Get the times
      startTime = timeframe[0];
      endTime = timeframe[1];
      if (RoutineData.isStartTimeBeforeEndTime(startTime, endTime)) {
        Map<String, Map<String, Map>> routineMap = {
          startTime: {
            endTime: {
              'startTime': startTime,
              'endTime': endTime,
              'RoutineName': _routineNameController.text,
              'Objective': _objectiveController.text
            }
          }
        };
        Routine newRoutine = Routine(routine: routineMap);
        showInSnackBar("New routine Added");
        routineProvider.storeRoutine(newRoutine);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    routineProvider = Provider.of<RoutineProvider>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.only(top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heading with action button to create the Routine
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          "Create Routine",
                          style: TextStyle(
                              color: AppTheme.lightPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2.0),
                        ),
                        // Underline
                        Container(
                            padding: const EdgeInsets.only(left: 30),
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 2,
                            decoration: BoxDecoration(
                              color: AppTheme.lightPrimary.withOpacity(0.7),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ))
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: const BorderSide(width: 2, color: AppTheme.lightPrimary),
                    ),
                    onPressed: () {
                      _handleSubmitted();
                    },
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(
                          color: AppTheme.lightPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0),
                    ),
                  )
                ],
              ),
              // Form field to create the routine one by one

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    controller: _routineNameController,
                    style: AppTheme.headlineTextStyle,
                    decoration: InputDecoration(
                        labelText: 'Routine Name',
                        labelStyle: AppTheme.labelStyle,
                        enabledBorder: AppTheme.enabledBorder,
                        focusedBorder: AppTheme.focusedBorder),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Routine';
                      }
                      return null;
                    },
                  ),
                  TimeFrame(key: _timeFrameKey),
                  TextFormField(
                    controller: _objectiveController,
                    style: AppTheme.bodyTextStyle,
                    decoration: InputDecoration(
                      labelText: 'Daily Goals',
                      labelStyle: AppTheme.labelStyle,
                      enabledBorder: AppTheme.enabledBorder,
                      focusedBorder: AppTheme.focusedBorder,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your Daily Goal';
                      }
                      return null;
                    },
                  )
                ],
              ),
              //To do
              //To display the routine that has been created
              //Expanded to take up the remaining space available in the screen
              Container(
                height: 300,
                margin: const EdgeInsets.only(top: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:minaroutine/provider/routine_provider.dart';
import 'package:minaroutine/screens/createroutine.dart';
import 'package:minaroutine/widgets/routineview.dart';
import 'package:minaroutine/screens/setting.dart';
import 'package:minaroutine/screens/stats.dart';
import 'package:minaroutine/setting/apptheme.dart';
import 'package:minaroutine/widgets/widget.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int activityIndex = 0;
  late RoutineProvider routineProvider;

  void onActivityChange(int newActivityIndex) {
    setState(() {
      activityIndex = newActivityIndex;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    routineProvider.getRoutine();
    routineProvider.getCurrentDayRoutineProgress();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      /// Home Page
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ClockWidget(),
          const WeekDays(),
          Consumer<RoutineProvider>(builder: (context, routineProvider, child) {
            return Column(
              children: [
                ProgressBar(progressValue: routineProvider.progressValue),
                routineProvider.routine.getRoutineMap.isEmpty
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            activityIndex = 2;
                          });
                        },
                        child: const Text(
                          "Create Routine",
                          style: AppTheme.headlineTextStyle,
                        ))
                    : const RoutineView()
              ],
            );
          })
        ],
      ),

      /// Statistics Page
      const Statistics(),

      /// Create/Update Routine Page
      const CreateRoutine(),

      /// Setting Page
      const Setting(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          child: pages[activityIndex],
        ),
      ),
      bottomNavigationBar:
          BottomNavBar(activityIndex: activityIndex, onActivityChange: onActivityChange),
    );
  }
}

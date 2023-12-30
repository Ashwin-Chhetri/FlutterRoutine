// import 'dart:math';

import 'package:flutter/material.dart';
import 'package:minaroutine/provider/routine_provider.dart';
// import 'package:minaroutine/setting/apptheme.dart';
import 'package:minaroutine/widgets/barchart.dart';
import 'package:minaroutine/widgets/heatmap.dart';
import 'package:provider/provider.dart';

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  late RoutineProvider routineProvider;
  final ScrollController _scrollController = ScrollController();
  // final BoxDecoration _boxDecoration = BoxDecoration(
  //     color: AppTheme.lightPrimary,
  //     borderRadius: BorderRadius.circular(30),
  //     boxShadow: const [
  //       //light shadow top-left
  //       BoxShadow(offset: Offset(-5, -5), blurRadius: 5, color: Colors.white30, spreadRadius: 9),
  //       //dark shadow bottom-right
  //       BoxShadow(offset: Offset(5, 5), blurRadius: 5, color: Colors.black38)
  //     ]);

  void _scrollToRight() {
    _scrollController.animateTo(
      _scrollController.offset + MediaQuery.of(context).size.width * 0.69,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _scrollToLeft() {
    _scrollController.animateTo(
      _scrollController.offset - MediaQuery.of(context).size.width * 0.69,
      curve: Curves.linear,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void initState() {
    routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    routineProvider.getRoutineHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // HeatMapCalendar
      child: Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: _scrollToLeft, icon: const Icon(Icons.arrow_left)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.68,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: 2,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: MediaQuery.of(context).size.width * 0.68,
                        //decoration: _boxDecoration,
                        child: Card(
                            elevation: 3,
                            child: Consumer<RoutineProvider>(
                              builder: (context, value, child) {
                                return index == 0
                                    ? MyHeatMap(
                                        routineHistortHeatMap:
                                            routineProvider.routineHistortHeatMap)
                                    : MyHeatMap(
                                        routineHistortHeatMap:
                                            routineProvider.routineHistortHeatMap);
                              },
                            )),
                      );
                    },
                  ),
                ),
                IconButton(onPressed: _scrollToRight, icon: const Icon(Icons.arrow_right)),
              ],
            ),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.only(bottom: 5),
                  child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 2,
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 65,
                          margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.all(10),
                        ),
                      );
                    },
                  )
                  // mainAxisAlignment: MainAxisAlignment.start,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  ),
            )
          ],
        ),
      ),
    );
  }
}

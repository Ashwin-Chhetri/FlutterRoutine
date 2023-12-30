import 'package:flutter/material.dart';
import 'package:minaroutine/app.dart';
import 'package:minaroutine/provider/routine_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => RoutineProvider(),
      )
    ],
    child: const Myapp(),
  ));
}

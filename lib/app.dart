import 'package:flutter/material.dart';
import 'package:minaroutine/screens/home.dart';
import 'package:minaroutine/setting/apptheme.dart';

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const Home());
  }
}

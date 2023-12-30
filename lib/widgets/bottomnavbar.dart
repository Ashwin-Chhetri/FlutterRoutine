import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:minaroutine/setting/apptheme.dart';

class BottomNavBar extends StatelessWidget {
  final int activityIndex;
  final Function(int) onActivityChange;
  final List<Map<String, String>> navIcons = [
    {'iconPath': 'assets/icons/home.svg', 'label': 'Home'},
    {'iconPath': 'assets/icons/calendar-alt.svg', 'label': 'Calendar'},
    {'iconPath': 'assets/icons/plus-rectangle.svg', 'label': 'Create'},
    {'iconPath': 'assets/icons/cog.svg', 'label': 'Setting'},
  ];
  BottomNavBar({super.key, required this.activityIndex, required this.onActivityChange});

  Widget getNavIcon(int navIconIndex) {
    if (activityIndex == navIconIndex) {
      return FilledButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(AppTheme.lightPrimary),
          elevation: MaterialStatePropertyAll(4),
          padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
          shape: MaterialStatePropertyAll<CircleBorder>(CircleBorder()),
        ),
        onPressed: () {
          onActivityChange(navIconIndex);
        },
        child: SvgPicture.asset(
          navIcons[navIconIndex]['iconPath']!,
          width: 30,
          colorFilter: const ColorFilter.mode(AppTheme.lightOnPrimary, BlendMode.srcIn),
        ),
      );
    } else {
      return FilledButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(AppTheme.lightBG),
          padding: MaterialStatePropertyAll(EdgeInsets.all(10)),
          shape: MaterialStatePropertyAll<CircleBorder>(CircleBorder()),
        ),
        onPressed: () {
          onActivityChange(navIconIndex);
        },
        child: SvgPicture.asset(
          navIcons[navIconIndex]['iconPath']!,
          width: 35,
          colorFilter: const ColorFilter.mode(AppTheme.lightPrimary, BlendMode.srcIn),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.08,
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      // decoration: BoxDecoration(
      //     color: AppTheme.lightBottomNavBackground,
      //     borderRadius: const BorderRadius.only(
      //       topLeft: Radius.circular(30),
      //       topRight: Radius.circular(30),
      //     ),
      //     boxShadow: const [
      //       BoxShadow(offset: Offset(0, 10), spreadRadius: 3, blurRadius: 8)
      //     ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(navIcons.length, (index) => getNavIcon(index)),
      ),
    );
  }
}

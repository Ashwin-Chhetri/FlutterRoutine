import 'package:flutter/material.dart';
import 'package:minaroutine/provider/routine_provider.dart';
import 'package:minaroutine/setting/apptheme.dart';
import 'package:provider/provider.dart';
//import 'package:minaroutine/widgets/containershadow.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late RoutineProvider routineProvider;
  final Widget lineDivider = Divider(
    height: 20,
    thickness: 2,
    color: AppTheme.lightPrimary.withOpacity(0.2),
  );

  @override
  void initState() {
    routineProvider = Provider.of<RoutineProvider>(context, listen: false);
    super.initState();
  }

  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
  }

  @override
  Widget build(BuildContext context) {
    double fullWidth = MediaQuery.of(context).size.width;
    double fullheight = MediaQuery.of(context).size.height;
    return Container(
      height: fullheight,
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading with action button to create the Routine
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "setting",
                      style: TextStyle(
                          color: AppTheme.lightPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.0),
                    ),
                    // Underline
                    Container(
                      padding: const EdgeInsets.only(left: 30),
                      width: fullWidth * 0.2,
                      height: 2,
                      decoration: BoxDecoration(
                        color: AppTheme.lightPrimary.withOpacity(0.7),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(40),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          // body
          SizedBox(
            width: fullWidth,
            height: fullheight * 0.79,
            //color: Colors.grey,
            child: ListView(
              children: [
                ListTile(
                  title: const Text(
                    'Delete Routine',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: const Text(
                    "Delete all the routines.",
                  ),
                  trailing: SizedBox(
                    width: 50,
                    height: 50,
                    child: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          routineProvider.deleteRoutine();
                          showInSnackBar("Routine Deleted");
                        }),
                  ),
                ),
                lineDivider,
                ListTile(
                  title: const Text('Font Size', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Size of the characters."),
                  trailing: Container(
                      width: 50,
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text('12', style: AppTheme.bodyTextStyle)),
                ),
                lineDivider,
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:minaroutine/setting/apptheme.dart';

class ProgressBar extends StatefulWidget {
  final double progressValue;
  const ProgressBar({super.key, required this.progressValue});

  @override
  State<ProgressBar> createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      height: 50,
      child: Row(children: [
        CustomPaint(
          painter: MyCustomPainter(progressValue: widget.progressValue),
          size: Size(MediaQuery.of(context).size.width * 0.8, 50), // padding of 16
        )
      ]),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  late double progressValue;

  MyCustomPainter({required this.progressValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.lightPrimary
      ..strokeWidth = 4;

    final startPoint = Offset(0, size.height / 2);
    final endPoint = Offset(size.width * progressValue, size.height / 2);

    canvas.drawLine(startPoint, endPoint, paint);

    final radius = size.height / 2;

    final center = Offset(size.width * progressValue, size.height / 2);

    canvas.drawCircle(center, radius, paint);

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 16,
    );

    final textSpan = TextSpan(
      text: '${(progressValue * 100).toInt()}%',
      style: textStyle,
    );

    final textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width - radius,
    );

    final xCenter = center.dx - textPainter.width / 2;
    final yCenter = center.dy - textPainter.height / 2;

    final offset = Offset(xCenter, yCenter);

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

import 'package:flutter/material.dart';
import 'package:ilocate/styles/colors.dart';

class ClipPathWidget extends StatelessWidget {
  const ClipPathWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: MyPainter(), size: const Size(double.infinity, 150));
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var controlPoint = Offset(size.width / 2.5, size.height / 2);
    var controlPoint2 = Offset(size.width / 1.3, size.height * 1.05);
    var endPoint = Offset(size.width, size.height / 1.05);

    Path path = Path()
      ..lineTo(0, size.height / 1.3)
      ..cubicTo(controlPoint.dx, controlPoint.dy, controlPoint2.dx,
          controlPoint2.dy, endPoint.dx, endPoint.dy)
      ..lineTo(size.width, 0)
      ..close();

    var paint1 = Paint()..color = ilocateAmber;

    canvas.drawPath(path, paint1);

    var controlPoint3 = Offset(size.width / 2, size.height / 3);
    var controlPoint4 = Offset(size.width / 1.3, size.height * 1.01);
    var endPoint2 = Offset(size.width, size.height / 1.3);

    Path path2 = Path()
      ..lineTo(0, size.height / 1.35)
      ..cubicTo(controlPoint3.dx, controlPoint3.dy, controlPoint4.dx,
          controlPoint4.dy, endPoint2.dx, endPoint2.dy)
      ..lineTo(size.width, 0)
      ..close();

    var paint2 = Paint()..color = ilocateYellow;

    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

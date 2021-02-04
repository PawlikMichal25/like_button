import 'package:like_button/src/utils/like_button_model.dart';
import 'package:like_button/src/utils/like_button_util.dart';
import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  CirclePainter({
    @required this.outerCircleRadiusProgress,
    @required this.innerCircleRadiusProgress,
    @required this.circleColor,
  });

  final Paint _circlePaint = Paint()..style = PaintingStyle.stroke;

  final double outerCircleRadiusProgress;
  final double innerCircleRadiusProgress;
  final CircleColor circleColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.width * 0.5;
    _updateCircleColor();
    final strokeWidth = outerCircleRadiusProgress * center - (innerCircleRadiusProgress * center);
    if (strokeWidth > 0.0) {
      _circlePaint.strokeWidth = strokeWidth;
      canvas.drawCircle(Offset(center, center), outerCircleRadiusProgress * center, _circlePaint);
    }
  }

  void _updateCircleColor() {
    var colorProgress = clamp(outerCircleRadiusProgress, 0.5, 1.0);
    colorProgress = mapValueFromRangeToRange(colorProgress, 0.5, 1.0, 0.0, 1.0);
    _circlePaint.color = Color.lerp(circleColor.start, circleColor.end, colorProgress);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate.runtimeType != runtimeType) {
      return true;
    }

    return oldDelegate is CirclePainter &&
        (oldDelegate.outerCircleRadiusProgress != outerCircleRadiusProgress ||
            oldDelegate.innerCircleRadiusProgress != innerCircleRadiusProgress ||
            oldDelegate.circleColor != circleColor);
  }
}

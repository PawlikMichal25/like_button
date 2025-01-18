import 'package:flutter/material.dart';

class BubblesColor {
  const BubblesColor({
    required this.dotPrimaryColor,
    required this.dotSecondaryColor,
    this.dotThirdColor,
    this.dotLastColor,
  });

  final Color dotPrimaryColor;
  final Color dotSecondaryColor;
  final Color? dotThirdColor;
  final Color? dotLastColor;

  Color get dotThirdColorReal => dotThirdColor ?? dotPrimaryColor;

  Color get dotLastColorReal => dotLastColor ?? dotSecondaryColor;
}

class CircleColor {
  const CircleColor({
    required this.start,
    required this.end,
  });

  final Color start;
  final Color end;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CircleColor && runtimeType == other.runtimeType && start == other.start && end == other.end;

  @override
  int get hashCode => start.hashCode ^ end.hashCode;
}

class OvershootCurve extends Curve {
  const OvershootCurve();

  static const double _period = 2.5;

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((_period + 1) * t + _period) + 1.0;
  }

  @override
  String toString() {
    return '$runtimeType($_period)';
  }
}

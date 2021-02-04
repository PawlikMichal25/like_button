import 'package:flutter/material.dart';

class BubblesColor {
  const BubblesColor({
    @required this.dotPrimaryColor,
    @required this.dotSecondaryColor,
    this.dotThirdColor,
    this.dotLastColor,
  });

  final Color dotPrimaryColor;
  final Color dotSecondaryColor;
  final Color dotThirdColor;
  final Color dotLastColor;

  Color get dotThirdColorReal => dotThirdColor ?? dotPrimaryColor;

  Color get dotLastColorReal => dotLastColor ?? dotSecondaryColor;
}

class CircleColor {
  final Color start;
  final Color end;

  const CircleColor({
    @required this.start,
    @required this.end,
  });

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is CircleColor && start == other.start && end == other.end;
  }

  @override
  int get hashCode => hashValues(start, end);
}

class OvershootCurve extends Curve {
  final period = 2.5;

  const OvershootCurve();

  @override
  double transform(double t) {
    assert(t >= 0.0 && t <= 1.0);
    t -= 1.0;
    return t * t * ((period + 1) * t + period) + 1.0;
  }

  @override
  String toString() {
    return '$runtimeType($period)';
  }
}

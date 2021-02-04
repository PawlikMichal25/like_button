import 'package:like_button/src/painter/circle_painter.dart';
import 'package:like_button/src/painter/bubbles_painter.dart';
import 'package:like_button/src/utils/like_button_model.dart';
import 'package:like_button/src/utils/like_button_typedef.dart';

import 'package:flutter/material.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({
    Key key,
    @required this.likeBuilder,
    @required this.isLiked,
    @required this.bubblesColor,
    @required this.circleColor,
    @required this.onTap,
    this.size = 30.0,
  })  : assert(size != null),
        super(key: key);

  ///size of like widget
  final double size;

  ///colors of bubbles
  final BubblesColor bubblesColor;

  ///colors of circle
  final CircleColor circleColor;

  /// tap call back of like button
  final LikeButtonTapCallback onTap;

  ///whether it is liked
  final bool isLiked;

  ///builder to create like widget
  final LikeWidgetBuilder likeBuilder;

  @override
  State<StatefulWidget> createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> with TickerProviderStateMixin {
  static const _animationDuration = Duration(milliseconds: 1000);

  double _bubblesSize;
  double _circleSize;

  AnimationController _controller;
  Animation<double> _outerCircleAnimation;
  Animation<double> _innerCircleAnimation;
  Animation<double> _scaleAnimation;
  Animation<double> _bubblesAnimation;

  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;

    _bubblesSize = widget.size * 2.0;
    _circleSize = widget.size * 0.8;

    _controller = AnimationController(duration: _animationDuration, vsync: this);

    _initControlAnimation();
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    _isLiked = widget.isLiked;

    if (_controller?.duration != _animationDuration) {
      _controller?.dispose();
      _controller = AnimationController(duration: _animationDuration, vsync: this);
      _initControlAnimation();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        final likeWidget = widget.likeBuilder.call(_isLiked ?? true);
        return Stack(
          overflow: Overflow.visible,
          children: [
            Positioned(
              top: (widget.size - _bubblesSize) / 2.0,
              left: (widget.size - _bubblesSize) / 2.0,
              child: CustomPaint(
                size: Size(_bubblesSize, _bubblesSize),
                painter: BubblesPainter(
                  currentProgress: _bubblesAnimation.value,
                  color1: widget.bubblesColor.dotPrimaryColor,
                  color2: widget.bubblesColor.dotSecondaryColor,
                  color3: widget.bubblesColor.dotThirdColorReal,
                  color4: widget.bubblesColor.dotLastColorReal,
                ),
              ),
            ),
            Positioned(
              top: (widget.size - _circleSize) / 2.0,
              left: (widget.size - _circleSize) / 2.0,
              child: CustomPaint(
                size: Size(_circleSize, _circleSize),
                painter: CirclePainter(
                  innerCircleRadiusProgress: _innerCircleAnimation.value,
                  outerCircleRadiusProgress: _outerCircleAnimation.value,
                  circleColor: widget.circleColor,
                ),
              ),
            ),
            Container(
              width: widget.size,
              height: widget.size,
              alignment: Alignment.center,
              child: Transform.scale(
                scale: ((_isLiked ?? true) && _controller.isAnimating) ? _scaleAnimation.value : 1.0,
                child: SizedBox(
                  height: widget.size,
                  width: widget.size,
                  child: likeWidget,
                ),
              ),
            ),
          ],
        );
      },
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Center(
        child: result,
      ),
    );
  }

  void onTap() {
    // if (_controller.isAnimating) {
    //   return;
    // }
    final newIsLiked = !(_isLiked ?? true);
    widget.onTap(newIsLiked);
    _handleIsLikeChanged(newIsLiked);
  }

  void _handleIsLikeChanged(bool newIsLiked) {
    if (newIsLiked != _isLiked) {
      _isLiked = newIsLiked;

      if (mounted) {
        setState(() {
          if (_isLiked) {
            _controller.reset();
            _controller.forward();
          }
        });
      }
    }
  }

  void _initControlAnimation() {
    _outerCircleAnimation = Tween<double>(begin: 0.1, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.ease),
      ),
    );
    _innerCircleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.ease),
      ),
    );
    _scaleAnimation = Tween<double>(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.7, curve: OvershootCurve()),
      ),
    );
    _bubblesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 1.0, curve: Curves.decelerate),
      ),
    );
  }
}

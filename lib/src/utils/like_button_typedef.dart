import 'package:flutter/material.dart';

/// tap call back
/// you can send your request here
/// if failed, return null
///
typedef LikeButtonTapCallback = void Function(bool isLiked);

///build widget when isLike is changing
typedef LikeWidgetBuilder = Widget Function(bool isLiked);

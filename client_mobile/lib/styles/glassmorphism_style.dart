import 'package:glass_kit/glass_kit.dart';
import 'package:flutter/material.dart';

/// A custom widget that provides a glass-like container with rounded edges.
class GlassContainerRounded extends StatelessWidget {
  /// The child widget to be displayed inside the container.
  final Widget child;
  /// The border radius of the container.
  final double borderRadius;
  /// The width of the container.
  final double width;
  /// The height of the container.
  final double height;
  /// The opacity of the container's background color.
  final double colorOpacity;
  /// The border color of the container.
  final Color borderColor;
  /// The margin around the container.
  final EdgeInsetsGeometry margin;
  /// The padding around the container.
  final EdgeInsetsGeometry padding;

  /// Contructor for the `GlassContainerRounded` widget.
  /// 
  /// - `child`: is the child widget
  /// - `colorOpacity`: specifies the opacity of the container's background color.
  /// - `borderColor`: specifies the color of the container's border.
  /// - `width`: specifies the width of the container.
  /// - `height`: specifies the height of the container.
  /// - `borderRadius`: specifies the border radius of the container.
  const GlassContainerRounded(
      {super.key,
      required this.child,
      required this.colorOpacity,
      required this.borderColor,
      required this.width,
      required this.height,
      required this.borderRadius,
      this.margin = const EdgeInsets.all(0),
      this.padding = const EdgeInsets.all(0)});

  @override
  Widget build(BuildContext context) {
    return GlassContainer.clearGlass(
      elevation: 0,
      margin: margin,
      padding: padding,
      width: width,
      height: height,
      blur: 55,
      borderWidth: 1.5,
      borderRadius: BorderRadius.circular(borderRadius),
      color: Colors.white.withOpacity(colorOpacity),
      borderColor: borderColor,
      child: child,
    );
  }
}

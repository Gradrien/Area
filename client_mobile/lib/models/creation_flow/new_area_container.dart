import 'package:client_mobile/models/area/area_content.dart';
import 'package:client_mobile/styles/glassmorphism_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A container widget for creating a new area with a glassmorphism-style design.
class NewAreaContainer extends StatefulWidget {
  /// The content of the area being created.
  final AreaContent areacontent;
  /// The child widget to display inside the container.
  final Widget child;
  /// Callback to notify step change.
  final Function() onStepChanged;

  /// Constructor for the `NewAreaContainer` widget.
  const NewAreaContainer({
    Key? key,
    required this.areacontent,
    required this.child,
    required this.onStepChanged,
  }) : super(key: key);

  @override
  _NewAreaContainer createState() => _NewAreaContainer();
}

/// The state of the [NewAreaContainer] widget.
class _NewAreaContainer extends State<NewAreaContainer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassContainerRounded(
        width: 360,
        height: 420,
        borderRadius: 15,
        borderColor: Colors.white,
        colorOpacity: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            widget.child,
            MaterialButton(
              shape: const CircleBorder(),
              onPressed: () {
                widget.onStepChanged(); // Change step here
              },
              child: SvgPicture.asset(
                'assets/next.svg',
                color: const Color(0xFF4E5AE8),
                height: 50,
                width: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

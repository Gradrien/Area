import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A widget that displays a checkmark to indicate the completion of a creation process.
class FinishedCreation extends StatelessWidget {
  /// Constructor for the `FinishedCreation` widget.
  const FinishedCreation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 230,
        child: SvgPicture.asset(
          'assets/checked.svg',
          color: const Color(0xFF4E5AE8),
          height: 128,
          width: 128,
        ),
      ),
    );
  }
}

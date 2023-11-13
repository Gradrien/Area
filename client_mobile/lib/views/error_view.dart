import 'package:client_mobile/router/route_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// View that is shown when an error occurs.
class ErrorView extends StatelessWidget {
  /// Error message to display
  final String? error;

  /// Constructor for the `ErrorView` widget.
  /// 
  /// - `error`: Error message to display
  const ErrorView({
    Key? key,
    this.error,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppPage.error.toTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error ?? ""),
            TextButton(
              onPressed: () {
                GoRouter.of(context).goNamed(AppPage.home.toName);
              },
              child: const Text(
                  "Back to Home"
              ),
            ),
          ],
        ),
      ),
    );
  }
}

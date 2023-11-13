import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../router/route_utils.dart';
import '../services/app_service.dart';

/// Splash screen page.
class SplashPage extends StatefulWidget {
  /// Constructor for the `SplashPage` widget.
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

/// State class for the `SplashPage` widget.
class _SplashPageState extends State<SplashPage> {
  /// Reference to the `AppService` instance.
  late AppService _appService;

  @override
  void initState() {
    _appService = Provider.of<AppService>(context, listen: false);
    onStartUp();
    super.initState();
  }

  /// Start up the application.
  void onStartUp() async {
    await _appService.onAppStart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppPage.splash.toTitle),
        ),
        body: const Center(
          child: SizedBox(
              width: 100, height: 100, child: CircularProgressIndicator()),
        ));
  }
}

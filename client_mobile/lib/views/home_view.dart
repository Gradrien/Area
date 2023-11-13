import 'package:client_mobile/models/area_container.dart';
import 'package:client_mobile/models/user.dart';
import 'package:client_mobile/services/area_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// The home view of the app.
class HomeView extends StatefulWidget {
  /// Constructor for the `HomeView` widget.
  /// 
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

/// The state of the `HomeView` widget.
class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final areaService = Provider.of<AreaService>(context, listen: false);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
          future: areaService.getProfile(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                User user = snapshot.data as User;
                return Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 22.0),
                        child: Text("Bienvenue ${user.getName}",
                            style: const TextStyle(
                                fontSize: 32, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.left),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 22.0),
                        child: Text(
                          "Mes automatisations",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const AreaView(),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            } else if (snapshot.hasError) {
              return const Center(child: Text("Error occured"));
            } else {
              return const Center(
                    child: SizedBox(
                        width: 100,
                        height: 100,
                        child: CircularProgressIndicator()),
                  );
            }
          },
        ),
      ),
    );
  }
}

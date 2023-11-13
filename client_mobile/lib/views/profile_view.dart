import 'package:client_mobile/models/area/service.dart';
import 'package:client_mobile/models/area_container.dart';
import 'package:client_mobile/models/connect_with_button.dart';
import 'package:client_mobile/services/area_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../router/route_utils.dart';
import '../services/auth_services.dart';

/// This is the profile page.
class Profile extends StatefulWidget {
  /// Constructor for the `Profile` widget.
  /// 
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

/// This is the state of the `Profile` widget.
class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final areaService = Provider.of<AreaService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder(
            future: Future.wait(
                [areaService.getProfile(context), areaService.getServices(context)]),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                User user = snapshot.data![0] as User;
                List<ServiceContent> services = snapshot.data![1] as List<ServiceContent>;
                return Padding(
                  padding: const EdgeInsets.only(top: 48.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 22.0),
                            child: Text("Mon Profil",
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: () async {
                              authService.logOut();
                              GoRouter.of(context)
                                  .goNamed(AppPage.login.toName);
                            },
                            child: SvgPicture.asset(
                              "assets/disconnect.svg",
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 22.0),
                        child: Text(
                          "Mes informations",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      AreaContainer(
                        padding: const EdgeInsets.only(
                            left: 19, right: 19, top: 10, bottom: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InformationField(
                                title: "Prénom", value: user.getName),
                            InformationField(
                                title: "Email", value: user.getEmail),
                            const InformationField(
                                title: "Mot de passe", value: "●●●●●●●●●"),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 22.0),
                        child: Text(
                          "Mes services",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      AreaContainer(
                          padding: const EdgeInsets.only(
                              left: 19, right: 19, top: 12, bottom: 12),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            shrinkWrap: true,
                            itemCount: services.length,
                            itemBuilder: (context, index) {
                              if (services[index].isEnabled) {
                                return ConnectedTo(serviceIcon: services[index].serviceIcon,
                                  onDelete: () async {
                                    await authService.deleteService(services[index].id);
                                    setState(() {
                                        areaService.getServices(context);
                                    });
                                  },
                                  serviceName: services[index].name,
                                );
                              } else {
                                return ConnectWith(
                                  serviceName: services[index].name,
                                  serviceIcon: services[index].serviceIcon,
                                  onPressed: () async {
                                    if (services[index].name == "Google") {
                                      await authService.loginWithGoogleService();
                                    } else if (services[index].name == "GitLab") {
                                      await authService.loginWithGitlab();
                                    } else if (services[index].name == "Spotify") {
                                      await authService.loginWithSpotify();
                                    } else if (services[index].name == "Microsoft") {
                                      await authService.loginWithMicrosoft();
                                    }
                                    setState(() {
                                      areaService.getServices(context);
                                    });
                                  },
                                );
                              }
                            },
                          )),
                    ],
                  ),
                );
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
            }),
      ),
    );
  }
}

/// This is the widget that displays the information of a service.
class InformationField extends StatelessWidget {
  /// Title of the information.
  final String title;
  /// Text of the information.
  final String value;

  /// Constructor for the `InformationField` widget.
  /// 
  /// - `title`: Title of the information.
  /// - `value`: Text of the information.
  const InformationField({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color.fromARGB(255, 149, 149, 149))),
        Text(value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            )),
      ],
    );
  }
}

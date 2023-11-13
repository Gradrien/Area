import 'package:client_mobile/views/home_view.dart';
import 'package:flutter/material.dart';
import '../views/create_area_view.dart';
import '../views/profile_view.dart';

/// This widget is responsible for displaying different screens based on the selected tab in the bottom navigation bar.
class Nav extends StatefulWidget {
  /// Constructor for the [Nav] widget.
  /// 
  const Nav({super.key});

  @override
  _NavState createState() => _NavState();
}

/// State class for the [Nav] widget.
class _NavState extends State<Nav> {
  /// The current selected tab in the bottom navigation bar.
  int currentTab = 0;
  /// The list of screens that will be displayed in the bottom navigation bar.
  final List<Widget> screens = [
    const HomeView(),
    const Profile(),
    const CreateAreaView(),
  ];

  /// Store the current selected tab in the bottom navigation bar.
  final PageStorageBucket bucket = PageStorageBucket();
  /// Widget that will be displayed in the bottom navigation bar.
  Widget currentScreen = const HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),
      floatingActionButton: currentTab == 0 ? FloatingActionButton(
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
                center: Alignment(0, 1.25),
                colors: [Color(0xFFC7CDFC), Color(0xFF4C5AF6)]
            ),
          ),
          child: const Icon(Icons.add),
        ),
        onPressed: () {
          setState(() {
            currentScreen = const CreateAreaView();
            currentTab = 2;
          });
        },
      ) : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: currentTab != 2 ? BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const HomeView();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home,
                          color: currentTab == 0
                              ? const Color(0xFF4C5AF6)
                              : const Color(0xFFC7CDFC),
                        ),
                        Text(
                          'Home',
                          style: TextStyle(
                            color: currentTab == 0
                                ? const Color(0xFF4C5AF6)
                                : const Color(0xFFC7CDFC),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Profile();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          color: currentTab == 1
                              ? const Color(0xFF4C5AF6)
                              : const Color(0xFFC7CDFC),
                        ),
                        Text(
                          'Profile',
                          style: TextStyle(
                            color: currentTab == 1
                                ? const Color(0xFF4C5AF6)
                                : const Color(0xFFC7CDFC),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ) : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/screens/requestes/request_list.dart';
import 'package:growthpad/view/screens/secretary_home/pages/dashboard.dart';
import 'package:growthpad/view/screens/secretary_home/pages/event.dart';
import 'package:growthpad/view/screens/secretary_home/pages/profile.dart';

import '../../../theme/colors.dart';
import '../../../util/assets.dart';

class SecretaryHome extends StatefulWidget {
  const SecretaryHome({Key? key}) : super(key: key);

  @override
  State<SecretaryHome> createState() => _SecretaryHomeState();
}

class _SecretaryHomeState extends State<SecretaryHome> {
  int currentIndex = 0;
  List<String> titles = ['Home', 'Events', 'Profile'];
  List<Widget> pages = [
    const SecretaryDashboard(),
    const SecretaryEvent(),
    const SecretaryProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: null,
            icon: Image.asset(Assets.growthpadLogo, width: 35, height: 35)),
        title: Text(titles[currentIndex]),
        centerTitle: true,
        titleTextStyle: TextStyles.h2Bold.copyWith(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_rounded),
            tooltip: 'Notifications',
          ),
          IconButton(
            onPressed: () {
              Get.to(() => const RequestList());
            },
            icon: const Icon(Icons.person_add_rounded),
            tooltip: 'Requests',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: AppColors.primaryColor,
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          indicatorColor: Colors.white.withOpacity(0.3),
          labelTextStyle: MaterialStateProperty.all(
              TextStyles.p3Normal.copyWith(color: Colors.white)),
          height: 70,
        ),
        child: NavigationBar(
          selectedIndex: currentIndex,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_rounded,
                  color: Colors.white.withOpacity(0.4)),
              selectedIcon: const Icon(Icons.home_rounded, color: Colors.white),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.calendar_month_rounded,
                  color: Colors.white.withOpacity(0.4)),
              selectedIcon:
                  const Icon(Icons.calendar_month_rounded, color: Colors.white),
              label: 'Events',
            ),
            NavigationDestination(
              icon: Icon(Icons.account_circle_rounded,
                  color: Colors.white.withOpacity(0.4)),
              selectedIcon:
                  const Icon(Icons.account_circle_rounded, color: Colors.white),
              label: 'Profile',
            ),
          ],
          onDestinationSelected: (val) => setState(() => currentIndex = val),
        ),
      ),
    );
  }
}

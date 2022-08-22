
import 'package:e_commerce_clean/presentations/main/pages/home/view/home_page.dart';
import 'package:e_commerce_clean/presentations/main/pages/notifications/notifications_page.dart';
import 'package:e_commerce_clean/presentations/main/pages/search/search_page.dart';
import 'package:e_commerce_clean/presentations/main/pages/settings/settings_page.dart';

import 'package:flutter/material.dart';

import '../resources/color_manager.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';





class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<Widget> pages = const [
    HomePage(),
    SearchPage(),
    NotificationsPage(),
    SettingsPage(),
  ];

  List<String> titles = [
    AppStrings.home,
    AppStrings.searchPage,
    AppStrings.notifications,
    AppStrings.settingsPage,
  ];

  var _title = AppStrings.home;

  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorManager.primary,
        elevation: 0,
        title: Text(
          _title,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        centerTitle: true,
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(color: ColorManager.grey, spreadRadius: AppSize.s1)
        ]),
        child: BottomNavigationBar(
          selectedItemColor: ColorManager.primary,
          unselectedItemColor: ColorManager.grey,
          currentIndex: _currentIndex,
          onTap: onTap,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: AppStrings.home),
            BottomNavigationBarItem(
                icon: Icon(Icons.search), label: AppStrings.searchPage),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: AppStrings.notifications),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: AppStrings.settingsPage),
          ],
        ),
      ),
    );
  }

  onTap(int index) {
    setState(() {
      _currentIndex = index;
      _title = titles[index];
    });
  }
}

import 'package:adoptconnect_app/constants/global_variables.dart';
import 'package:adoptconnect_app/features/child_cases/child_cases_screen.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class BottomBar extends StatefulWidget {
  static const String routeName = 'actual-home';
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _page = 0;
  int _casesCount = 10;

  List<Widget> pages = [
    const ChildCasesScreen(),
    const Center(
      child: Text("Profile"),
    ),
  ];

  void updatePage(int page) {
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updatePage,
        currentIndex: _page,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        backgroundColor: GlobalVariables.primaryColor,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        iconSize: 30,
        items: [
          BottomNavigationBarItem(
              icon: badges.Badge(
                badgeContent: Text(
                  '$_casesCount',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                badgeStyle: const badges.BadgeStyle(
                  elevation: 0,
                ),
                child: const Icon(Icons.person_outlined),
              ),
              activeIcon: badges.Badge(
                  badgeContent: Text(
                    '$_casesCount',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    elevation: 0,
                  ),
                  child: const Icon(Icons.person)),
              label: 'Cases'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: 'Profile'),
        ],
      ),
    );
  }
}
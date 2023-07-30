import 'package:chatXpress/components/Home.dart';
import 'package:chatXpress/components/Settings.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../assets/colors/my_colors.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  final List<Widget> navigationScreens = [Home(), Settings()];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: navigationScreens,
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 3),
            child: GNav(
              tabBackgroundColor: MyColors.greenForNavigationBar,
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              tabs: [
                GButton(
                  icon: LineIcons.history,
                  text: 'History',
                ),
                GButton(
                  icon: LineIcons.cog,
                  text: 'Settings',
                )
              ],
            ),
          )),
    );
  }
}

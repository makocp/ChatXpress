import 'package:chatXpress/components/Home.dart';
import 'package:chatXpress/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../assets/colors/my_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> navigationScreens = [const Home(), const SettingsPage()];

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
              tabs: const [
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

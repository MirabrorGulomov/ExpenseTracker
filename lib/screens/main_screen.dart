import 'package:expense_tracker_app/screens/account/account_screen.dart';
import 'package:expense_tracker_app/screens/details/details_screen.dart';
import 'package:expense_tracker_app/screens/stats/stats_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'home/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  PageController pageController = PageController();
  List<Widget> pages = const [
    HomeScreen(),
    StatsScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: GNav(
        padding: const EdgeInsets.all(32),
        backgroundColor: Colors.grey.shade100,
        activeColor: const Color(0xff492A53),
        color: Colors.grey.shade600,
        selectedIndex: currentIndex,
        gap: 8,
        onTabChange: (value) {
          setState(() {
            currentIndex = value;
          });
        },
        tabs: [
          GButton(
            icon: Icons.home,
            text: "Home",
            textStyle: GoogleFonts.robotoCondensed(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xff492A53),
            ),
          ),
          GButton(
            icon: Icons.stacked_line_chart_outlined,
            text: "Stats",
            textStyle: GoogleFonts.robotoCondensed(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xff492A53),
            ),
          ),
          GButton(
            icon: Icons.person,
            text: "Profile",
            textStyle: GoogleFonts.robotoCondensed(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xff492A53),
            ),
          ),
        ],
      ),
    );
  }
}

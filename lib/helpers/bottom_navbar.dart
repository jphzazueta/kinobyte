import 'package:flutter/material.dart';

class BottomNavbar extends StatelessWidget {
  final int currentPageIndex;
  final Function(int) onTabTapped;  // callback for handling page switching

  const BottomNavbar({
    super.key,
    this.currentPageIndex = 0,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(color:Colors.white)
        ),
      ),
      child: NavigationBar(
        backgroundColor: const Color(0xFF06062B),
        // surfaceTintColor: Colors.grey,
        onDestinationSelected: onTabTapped,
        selectedIndex: currentPageIndex,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.movie_creation_outlined,
              color: Colors.white,
            ), 
            selectedIcon: Icon(Icons.movie_creation),
            label: 'Watched',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.bar_chart_rounded,
              color: Colors.white,
            ), 
            selectedIcon: Icon(Icons.bar_chart_rounded),
            label: 'Stats')
        ]
      ),
    );
  }
}
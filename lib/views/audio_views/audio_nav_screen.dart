import 'package:flutter/material.dart';
import 'package:noticias_sin_filtro/views/audio_views/audio_main_screen.dart';

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int _selectedIndex = 0; //stores the selected button index
  /*
    Generating the main screens
  */
  final _screens = [
    MainScreen(),
    const Scaffold(body: Center(child: Text('Explore'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* 
        Generating bottom navbar
      */
      body: Stack(
        children: _screens
            // here we handle the screens rendering ontouch
            .asMap()
            .map(
              (i, screen) => MapEntry(
                i,
                Offstage(offstage: _selectedIndex != i, child: screen),
              ),
            )
            .values
            .toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // anonymous function that return the selected index.
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color.fromARGB(185, 0, 0, 0),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: const [
          // Home buttom
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          // Explore buttom
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore_outlined),
            label: 'Explore',
          ),
        ],
      ),
    );
  }
}

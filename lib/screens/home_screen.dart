import 'package:flutter/material.dart';
import 'packages_screen.dart';
import 'my_trips_screen.dart';
import 'profile_screen.dart';
import 'ai_chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    PackagesScreen(),
    MyTripsScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      extendBody: true, // smooth look with bottom nav
      floatingActionButton: FloatingActionButton(
        elevation: 6,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AIChatScreen(),
            ),
          );
        },
        child: Image.asset(
          "assests/images/ai_icon.png",
          height: 40,
        ),
      ),
      body: SafeArea( // important for iOS notch
        child: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF90CAF9),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF0D47A1),
        unselectedItemColor: const Color(0xFF546E7A),
        elevation: 14,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Packages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'My Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile'
          )
        ],
      ),
    );
  }
}
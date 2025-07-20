import 'package:flutter/material.dart';

// Mock constants to replace the missing ones
class MockB4SColors {
  static const Color modalsBackgroundColor = Color(0xFFF8F9FA);
  static const Color buttonRedColor = Color(0xFFE74C3C);
}

class MockB4SAssets {
  static const String registerIcon = 'assets/icons/register.png';
  static const String comunityIcon = 'assets/icons/community.png';
  static const String profileIcon = 'assets/icons/profile.png';
}

// Mock controller for the home screen
class MockHomeController {
  int currentIndex = 0;
  final PageController pageController = PageController();

  void changePage(int index) {
    currentIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}

// Mock custom nav bar item
class MockCustomNavBarItem extends StatelessWidget {
  final String imageRoute;
  final String name;
  final bool selected;
  final VoidCallback onTap;

  const MockCustomNavBarItem({
    super.key,
    required this.imageRoute,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: selected ? MockB4SColors.buttonRedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mock icon (using a simple container instead of actual image)
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.grey[600],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getIconForRoute(imageRoute),
                size: 16,
                color: selected ? MockB4SColors.buttonRedColor : Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              name,
              style: TextStyle(
                fontSize: 10,
                color: selected ? Colors.white : Colors.grey[600],
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForRoute(String route) {
    switch (route) {
      case MockB4SAssets.registerIcon:
        return Icons.calendar_today;
      case MockB4SAssets.comunityIcon:
        return Icons.people;
      case MockB4SAssets.profileIcon:
        return Icons.person;
      default:
        return Icons.home;
    }
  }
}

// Mock screens for the page view
class MockRegisterScreen extends StatelessWidget {
  const MockRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              size: 48,
              color: MockB4SColors.buttonRedColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Mi Temporada',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Registra tus actividades',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class MockCommunityScreen extends StatelessWidget {
  const MockCommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people, size: 48, color: MockB4SColors.buttonRedColor),
            const SizedBox(height: 16),
            Text(
              'Comunidad',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Conecta con otros',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

class MockProfileScreen extends StatelessWidget {
  const MockProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 48, color: MockB4SColors.buttonRedColor),
            const SizedBox(height: 16),
            Text(
              'Perfil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tu información personal',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// Main mock home screen widget
class Brain4GoalsDemo extends StatefulWidget {
  const Brain4GoalsDemo({super.key});

  @override
  State<Brain4GoalsDemo> createState() => _Brain4GoalsDemoState();
}

class _Brain4GoalsDemoState extends State<Brain4GoalsDemo> {
  final MockHomeController controller = MockHomeController();

  @override
  void initState() {
    super.initState();
    // Initialize the controller
    controller.pageController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller.pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) {
          setState(() {
            controller.currentIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          MockRegisterScreen(),
          MockCommunityScreen(),
          MockProfileScreen(),
        ],
      ),
      bottomNavigationBar: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        child: BottomAppBar(
          notchMargin: 8,
          elevation: 0,
          padding: const EdgeInsets.only(top: 2),
          color: MockB4SColors.modalsBackgroundColor,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Expanded(
                child: MockCustomNavBarItem(
                  imageRoute: MockB4SAssets.registerIcon,
                  name: "Mi temporada",
                  selected: false, // Will be updated by controller
                  onTap: () {}, // Will be connected to controller
                ),
              ),
              Container(
                height: double.infinity,
                width: 1,
                color: const Color(0xFFE1E1E1),
              ),
              Expanded(
                child: MockCustomNavBarItem(
                  imageRoute: MockB4SAssets.comunityIcon,
                  name: "Comunidad",
                  selected: false, // Will be updated by controller
                  onTap: () {}, // Will be connected to controller
                ),
              ),
              Container(
                height: double.infinity,
                width: 1,
                color: const Color(0xFFE1E1E1),
              ),
              Expanded(
                child: MockCustomNavBarItem(
                  imageRoute: MockB4SAssets.profileIcon,
                  name: "Perfil",
                  selected: false, // Will be updated by controller
                  onTap: () {}, // Will be connected to controller
                ),
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

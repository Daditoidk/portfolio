import 'package:flutter/material.dart';
import 'package:portfolio_web/screens/portfolio/sections/projects%20section/demos/b4s%20demo/screens/community/community_screen.dart';
import 'season/field_screen.dart';
import 'profile/profile_screen.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';
import '../b4s_colors.dart';

class B4SDemoNavigationShell extends StatefulWidget {
  const B4SDemoNavigationShell({super.key});

  @override
  State<B4SDemoNavigationShell> createState() => _B4SDemoNavigationShellState();
}

class _B4SDemoNavigationShellState extends State<B4SDemoNavigationShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [FieldScreen(), CommunityScreen(), ProfileScreen()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: B4SDemoColors.modalsBackground,
        selectedItemColor: B4SDemoColors.buttonRed,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.sports_soccer),
            label: l10n.seasonTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: l10n.communityTab,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: l10n.profileTab,
          ),
        ],
      ),
    );
  }
}

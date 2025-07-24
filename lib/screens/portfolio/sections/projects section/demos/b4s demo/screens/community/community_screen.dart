import 'package:flutter/material.dart';
import '../../b4s_colors.dart';
import '../../widgets/b4s_custom_appbar.dart';
import './global_tab.dart';
import './local_tab.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        B4SCustomAppBar(
          title: l10n.communityWeeklyTitle,
          showBackButton: false,
          showIcons: false,
          titleStyle: b4SCustomAppBarTitleStyle.copyWith(fontSize: 18),
        ),
        Container(
          color: const Color(0xff232323),
          // Remove horizontal padding to allow full width
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: B4SDemoColors.buttonRed,
              // Remove borderRadius for square corners
            ),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize
                .tab, // Make indicator fill the tab (full width)
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white54,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
            tabs: [
              Tab(text: l10n.communityTabWeekly),
              Tab(text: l10n.communityTabGlobal),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [LocalCommunityTab(), GlobalCommunityTab()],
          ),
        ),
      ],
    );
  }
}

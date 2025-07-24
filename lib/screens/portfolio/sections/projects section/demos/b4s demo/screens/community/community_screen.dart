import 'package:flutter/material.dart';
import '../../b4s_colors.dart';
import '../../widgets/b4s_custom_appbar.dart';
import './global_tab.dart';
import './local_tab.dart';

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
    return Column(
      children: [
        B4SCustomAppBar(
          title: 'Tabla de posición semanal',
          showBackButton: false,
          showIcons: false,
          titleStyle: b4SCustomAppBarTitleStyle.copyWith(fontSize: 18),
        ),
        Container(
          color: const Color(0xff232323),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: B4SDemoColors.buttonRed,
              borderRadius: BorderRadius.circular(8),
            ),
            dividerColor: Colors.transparent,
            indicatorSize: TabBarIndicatorSize.tab,
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
            tabs: const [Tab(text: 'Actual'), Tab(text: 'Global')],
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

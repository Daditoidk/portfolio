import 'package:flutter/material.dart';
import '../../widgets/b4s_custom_appbar.dart';
import '../../widgets/profile_card_demo.dart';
import '../../b4s_colors.dart';
import '../../widgets/b4s_popup.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Widget? _popup;

  void _dismissPopup() {
    setState(() {
      _popup = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: const Color(0xff1F2022),
          appBar: B4SCustomAppBar(
            title: '',
            showBackButton: false,
            showIcons: false,
            actionIcon: IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => _showDemoFeaturePopup(l10n),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff172023), Color(0xff8E0D17)],
                begin: Alignment(0, 3),
                end: Alignment.topRight,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      color: const Color(0xff1F2022),
                      child: Column(
                        children: [
                          // No vertical padding here
                          const Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: ProfileCardDemo(),
                          ),
                        ],
                      ),
                    ),

                    // Promedio mensual del jugador
                    _MonthlyStatsRow(l10n: l10n),

                    const SizedBox(height: 16),
                    // Consejos button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: B4SDemoColors.buttonRed,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          icon: const Icon(Icons.chat_bubble_outline),
                          label: Text(
                            l10n.profileAdviceButton,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          onPressed: () => _showDemoFeaturePopup(l10n),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Profile grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _ProfileStatsGrid(l10n: l10n),
                    ),
                    const SizedBox(height: 16),
                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.show_chart,
                              color: Colors.white,
                            ),
                            title: Text(
                              l10n.profileActionPerformance,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            onTap: () => _showDemoFeaturePopup(l10n),
                            tileColor: Color(0xFF303539),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ListTile(
                            leading: const Icon(
                              Icons.emoji_events,
                              color: Colors.white,
                            ),
                            title: Text(
                              l10n.profileActionAchievements,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            onTap: () => _showDemoFeaturePopup(l10n),
                            tileColor: Color(0xFF303539),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ListTile(
                            leading: const Icon(
                              Icons.assignment_turned_in,
                              color: Colors.white,
                            ),
                            title: Text(
                              l10n.profileActionExternalReport,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            onTap: () => _showDemoFeaturePopup(l10n),
                            tileColor: Color(0xFF303539),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_popup != null)
          Positioned.fill(
            child: Container(
              color: Colors.black.withValues(alpha: 0.45),
              child: Center(child: _popup),
            ),
          ),
      ],
    );
  }

  void _showDemoFeaturePopup(AppLocalizations l10n) {
    setState(() {
      _popup = B4SPopup(
        title: l10n.profilePopupTitle,
        content: Text(l10n.profilePopupContent),
        actions: [
          TextButton(
            onPressed: _dismissPopup,
            child: Text(l10n.profilePopupOk),
          ),
        ],
      );
    });
  }
}

class _MonthlyStatsRow extends StatelessWidget {
  final AppLocalizations l10n;
  const _MonthlyStatsRow({required this.l10n});

  @override
  Widget build(BuildContext context) {
    // Demo values and colors
    final stats = [
      {
        'value': 81,
        'label': l10n.profileStatPsychological,
        'color': Color(0xFF11D59A),
        'icon': Icons.arrow_upward,
      },
      {
        'value': 43,
        'label': l10n.profileStatTechnical,
        'color': Color(0xFFF4A836),
        'icon': Icons.arrow_downward,
      },
      {
        'value': 61,
        'label': l10n.profileStatTactical,
        'color': Color(0xFFFF686D),
        'icon': Icons.arrow_downward,
      },
      {
        'value': 86,
        'label': l10n.profileStatPhysical,
        'color': Color(0xFFC16CE9),
        'icon': Icons.arrow_upward,
      },
    ];
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        color: Color(0xff1F2022),
      ),
      padding: EdgeInsets.only(bottom: 16, top: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                l10n.profileMonthlyAverage,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < stats.length; i++) ...[
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              stats[i]['icon'] as IconData,
                              color: stats[i]['color'] as Color,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              stats[i]['value'].toString(),
                              style: TextStyle(
                                color: stats[i]['color'] as Color,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          stats[i]['label'] as String,
                          style: TextStyle(
                            color: stats[i]['color'] as Color,
                            fontWeight: FontWeight.w500,
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (i < stats.length - 1)
                    SizedBox(
                      width: 8,
                      child: Center(
                        child: Container(
                          height: 24,
                          width: 1,
                          color: Colors.white24,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileStatsGrid extends StatelessWidget {
  final AppLocalizations l10n;
  const _ProfileStatsGrid({required this.l10n});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'value': '2', 'label': l10n.profileGridStreak},
      {'value': '598', 'label': l10n.profileGridExp},
      {'value': 'GOLD', 'label': l10n.profileGridGold},
      {'value': '5', 'label': l10n.profileGridBadges},
    ];
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.0,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children:
          stats
              .map(
                (stat) => _ProfileGridItem(
                  value: stat['value']!,
                  label: stat['label']!,
                ),
              )
              .toList(),
    );
  }
}

class _ProfileGridItem extends StatelessWidget {
  final String value;
  final String label;
  const _ProfileGridItem({required this.value, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.white),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white.withValues(alpha: 0.03),
      ),
      padding: const EdgeInsets.fromLTRB(30, 8, 0, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.5,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}

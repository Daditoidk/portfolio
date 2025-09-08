import 'package:flutter/material.dart';
import '../../b4s_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';

const String kB4SLogoAsset = 'assets/demos/b4s/logo_clean.svg';

class GlobalCommunityTab extends StatelessWidget {
  const GlobalCommunityTab({super.key});

  // Mock user data
  final List<Map<String, dynamic>> users = const [
    // 20 mock users for demo
    {
      'name': 'Paul C. Ramos',
      'avatar': kB4SLogoAsset,
      'points': 5075,
      'isCurrent': true,
    },
    {
      'name': 'Derrick L. Thoman',
      'avatar': kB4SLogoAsset,
      'points': 4985,
      'isCurrent': false,
    },
    {
      'name': 'Kelsey T. Donovan',
      'avatar': kB4SLogoAsset,
      'points': 4642,
      'isCurrent': false,
    },
    {
      'name': 'Jack L. Gregory',
      'avatar': kB4SLogoAsset,
      'points': 3874,
      'isCurrent': false,
    },
    {
      'name': 'Mary R. Mercado',
      'avatar': kB4SLogoAsset,
      'points': 3567,
      'isCurrent': false,
    },
    {
      'name': 'Theresa N. Maki',
      'avatar': kB4SLogoAsset,
      'points': 3478,
      'isCurrent': false,
    },
    {
      'name': 'James R. Stokes',
      'avatar': kB4SLogoAsset,
      'points': 3257,
      'isCurrent': false,
    },
    {
      'name': 'David B. Rodriguez',
      'avatar': kB4SLogoAsset,
      'points': 3250,
      'isCurrent': false,
    },
    {
      'name': 'Annette R. Allen',
      'avatar': kB4SLogoAsset,
      'points': 3212,
      'isCurrent': false,
    },
    {
      'name': 'Lucas M. White',
      'avatar': kB4SLogoAsset,
      'points': 3100,
      'isCurrent': false,
    },
    {
      'name': 'Sophie L. Turner',
      'avatar': kB4SLogoAsset,
      'points': 3050,
      'isCurrent': false,
    },
    {
      'name': 'Carlos G. Perez',
      'avatar': kB4SLogoAsset,
      'points': 2990,
      'isCurrent': false,
    },
    {
      'name': 'Emma S. Clark',
      'avatar': kB4SLogoAsset,
      'points': 2950,
      'isCurrent': false,
    },
    {
      'name': 'Noah J. Lee',
      'avatar': kB4SLogoAsset,
      'points': 2900,
      'isCurrent': false,
    },
    {
      'name': 'Olivia K. Adams',
      'avatar': kB4SLogoAsset,
      'points': 2850,
      'isCurrent': false,
    },
    {
      'name': 'Mason D. Evans',
      'avatar': kB4SLogoAsset,
      'points': 2800,
      'isCurrent': false,
    },
    {
      'name': 'Ava F. Scott',
      'avatar': kB4SLogoAsset,
      'points': 2750,
      'isCurrent': false,
    },
    {
      'name': 'Ethan H. King',
      'avatar': kB4SLogoAsset,
      'points': 2700,
      'isCurrent': false,
    },
    {
      'name': 'Mia I. Wright',
      'avatar': kB4SLogoAsset,
      'points': 2650,
      'isCurrent': false,
    },
    {
      'name': 'Logan J. Baker',
      'avatar': kB4SLogoAsset,
      'points': 2600,
      'isCurrent': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: const Color(0xff1F2022),
      child: Column(
        children: [
          // Leaderboard header
          Container(
            color: const Color(0xff515151),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    l10n.communityLeaderboardHeaderNumber,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(width: 48),
                Expanded(
                  child: Text(
                    l10n.communityLeaderboardHeaderAthlete,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Text(
                  l10n.communityLeaderboardHeaderPoints,
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          // Leaderboard list
          Expanded(
            child:
                users.isEmpty
                    ? SizedBox(
                      height: 200,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                          l10n.communityNoUsersGlobal,
                          style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                    : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final isCurrent = user['isCurrent'] as bool;
                        return Container(
                          color:
                              isCurrent
                                  ? B4SDemoColors.buttonRed
                                  : const Color(0xff3E3E3E),
                          child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: Colors.white,
                            child: SvgPicture.asset(
                              user['avatar'],
                              width: 32,
                              height: 32,
                              ),
                            ),
                            title: Text(
                              user['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle:
                                isCurrent
                              ? Text(
                                  l10n.communityCurrentUser,
                                  style: const TextStyle(color: Colors.white70),
                                )
                                    : null,
                            trailing: Text(
                              user['points'].toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

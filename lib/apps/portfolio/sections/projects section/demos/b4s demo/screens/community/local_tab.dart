import 'package:flutter/material.dart';
import '../../b4s_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:portfolio_web/core/l10n/app_localizations.dart';

const String kB4SLogoAsset = 'assets/demos/b4s/logo_clean.svg';

class LocalCommunityTab extends StatefulWidget {
  const LocalCommunityTab({super.key});

  @override
  State<LocalCommunityTab> createState() => _LocalCommunityTabState();
}

class _LocalCommunityTabState extends State<LocalCommunityTab> {
  // Mock filter state
  String stage = 'Benjamin';
  String category = 'All';
  String gender = 'Mixed';
  String league = 'Bronze';

  // Mock user data
  final List<Map<String, dynamic>> allUsers = [
    // 40 mock users for demo
    {
      'name': 'Paul C. Ramos',
      'avatar': kB4SLogoAsset,
      'points': 5075,
      'isCurrent': true,
      'stage': 'Benjamin',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Derrick L. Thoman',
      'avatar': kB4SLogoAsset,
      'points': 4985,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'B',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Kelsey T. Donovan',
      'avatar': kB4SLogoAsset,
      'points': 4642,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Jack L. Gregory',
      'avatar': kB4SLogoAsset,
      'points': 3874,
      'isCurrent': false,
      'stage': 'Cadet',
      'category': 'C',
      'gender': 'M',
      'league': 'Gold',
    },
    {
      'name': 'Mary R. Mercado',
      'avatar': kB4SLogoAsset,
      'points': 3567,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Theresa N. Maki',
      'avatar': kB4SLogoAsset,
      'points': 3478,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'B',
      'gender': 'F',
      'league': 'Silver',
    },
    {
      'name': 'James R. Stokes',
      'avatar': kB4SLogoAsset,
      'points': 3257,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'C',
      'gender': 'M',
      'league': 'Gold',
    },
    {
      'name': 'David B. Rodriguez',
      'avatar': kB4SLogoAsset,
      'points': 3250,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'B',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Annette R. Allen',
      'avatar': kB4SLogoAsset,
      'points': 3212,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Lucas M. White',
      'avatar': kB4SLogoAsset,
      'points': 3100,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Sophie L. Turner',
      'avatar': kB4SLogoAsset,
      'points': 3050,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Silver',
    },
    {
      'name': 'Carlos G. Perez',
      'avatar': kB4SLogoAsset,
      'points': 2990,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Emma S. Clark',
      'avatar': kB4SLogoAsset,
      'points': 2950,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Noah J. Lee',
      'avatar': kB4SLogoAsset,
      'points': 2900,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Olivia K. Adams',
      'avatar': kB4SLogoAsset,
      'points': 2850,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Mason D. Evans',
      'avatar': kB4SLogoAsset,
      'points': 2800,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Ava F. Scott',
      'avatar': kB4SLogoAsset,
      'points': 2750,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Silver',
    },
    {
      'name': 'Ethan H. King',
      'avatar': kB4SLogoAsset,
      'points': 2700,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Mia I. Wright',
      'avatar': kB4SLogoAsset,
      'points': 2650,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Logan J. Baker',
      'avatar': kB4SLogoAsset,
      'points': 2600,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Ella K. Nelson',
      'avatar': kB4SLogoAsset,
      'points': 2550,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Jacob L. Carter',
      'avatar': kB4SLogoAsset,
      'points': 2500,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Charlotte M. Mitchell',
      'avatar': kB4SLogoAsset,
      'points': 2450,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Silver',
    },
    {
      'name': 'William N. Perez',
      'avatar': kB4SLogoAsset,
      'points': 2400,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Amelia O. Roberts',
      'avatar': kB4SLogoAsset,
      'points': 2350,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Henry P. Murphy',
      'avatar': kB4SLogoAsset,
      'points': 2300,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Grace Q. Foster',
      'avatar': kB4SLogoAsset,
      'points': 2250,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Benjamin R. Bell',
      'avatar': kB4SLogoAsset,
      'points': 2200,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Zoe S. Cooper',
      'avatar': kB4SLogoAsset,
      'points': 2150,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Silver',
    },
    {
      'name': 'Alexander T. Ward',
      'avatar': kB4SLogoAsset,
      'points': 2100,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Lily U. Morgan',
      'avatar': kB4SLogoAsset,
      'points': 2050,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Samuel V. Reed',
      'avatar': kB4SLogoAsset,
      'points': 2000,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Chloe W. Bailey',
      'avatar': kB4SLogoAsset,
      'points': 1950,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Matthew X. Rivera',
      'avatar': kB4SLogoAsset,
      'points': 1900,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Scarlett Y. Kim',
      'avatar': kB4SLogoAsset,
      'points': 1850,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Silver',
    },
    {
      'name': 'Daniel Z. Cox',
      'avatar': kB4SLogoAsset,
      'points': 1800,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Victoria A. Brooks',
      'avatar': kB4SLogoAsset,
      'points': 1750,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Jackson B. Sanders',
      'avatar': kB4SLogoAsset,
      'points': 1700,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Penelope C. Price',
      'avatar': kB4SLogoAsset,
      'points': 1650,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Sebastian D. Bennett',
      'avatar': kB4SLogoAsset,
      'points': 1600,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Layla E. Barnes',
      'avatar': kB4SLogoAsset,
      'points': 1550,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Silver',
    },
    {
      'name': 'Aiden F. Ross',
      'avatar': kB4SLogoAsset,
      'points': 1500,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Hannah G. Henderson',
      'avatar': kB4SLogoAsset,
      'points': 1450,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Lucas H. Bryant',
      'avatar': kB4SLogoAsset,
      'points': 1400,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Mila I. Griffin',
      'avatar': kB4SLogoAsset,
      'points': 1350,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Elijah J. Russell',
      'avatar': kB4SLogoAsset,
      'points': 1300,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Aria K. Hayes',
      'avatar': kB4SLogoAsset,
      'points': 1250,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Silver',
    },
    {
      'name': 'Logan L. Patterson',
      'avatar': kB4SLogoAsset,
      'points': 1200,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronze',
    },
    {
      'name': 'Sofia M. Simmons',
      'avatar': kB4SLogoAsset,
      'points': 1150,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Mason N. Alexander',
      'avatar': kB4SLogoAsset,
      'points': 1100,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Silver',
    },
    {
      'name': 'Camila O. Griffin',
      'avatar': kB4SLogoAsset,
      'points': 1050,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronze',
    },
    {
      'name': 'Oliver P. Ford',
      'avatar': kB4SLogoAsset,
      'points': 1000,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronze',
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    return allUsers.where((user) {
      final stageMatch = (stage == 'All' || user['stage'] == stage);
        final categoryMatch =
          (category == 'All' ||
          category == 'None' ||
          user['category'] == category);
      final genderMatch = (gender == 'Mixed' || user['gender'] == gender);
        final leagueMatch = (league == '' || user['league'] == league);
        return stageMatch && categoryMatch && genderMatch && leagueMatch;
      }).toList()
      ..sort((a, b) => b['points'].compareTo(a['points']));
  }

  // League colorsr
  LinearGradient getLeagueGradient() {
    switch (league) {
      case 'Bronze':
        return const LinearGradient(
          colors: [Color(0xFFEF8D31), Color(0x00EF8D31)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Silver':
        return const LinearGradient(
          colors: [Color(0xFFA7B5C0), Color(0x007B7B7B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Gold':
        return const LinearGradient(
          colors: [Color(0xFFF6C619), Color(0x00F6C619)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(colors: [Colors.grey, Colors.white]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      color: const Color(0xff1F2022),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Filters
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                children: [
                  _buildDropdown(
                    l10n.communityFilterStage,
                    stage,
                    [
                      'Benjamin',
                      'Alevin',
                      'Cadet',
                      'Infant',
                      'Youth',
                      'Amateur',
                      'All',
                    ],
                    (v) => setState(() => stage = v),
                    displayValues: [
                      l10n.communityFilterOptionBenjamin,
                      l10n.communityFilterOptionAlevin,
                      l10n.communityFilterOptionCadete,
                      l10n.communityFilterOptionInfantil,
                      l10n.communityFilterOptionJuvenil,
                      l10n.communityFilterOptionAmateur,
                      l10n.communityFilterOptionAll,
                    ],
                  ),
                  const SizedBox(width: 8),
                  _buildDropdown(
                    l10n.communityFilterCategory,
                    category,
                    ['None', 'A', 'B', 'C', 'All'],
                    (v) => setState(() => category = v),
                    displayValues: [
                      l10n.communityFilterOptionNone,
                      l10n.communityFilterOptionA,
                      l10n.communityFilterOptionB,
                      l10n.communityFilterOptionC,
                      l10n.communityFilterOptionAll,
                    ],
                  ),
                  const SizedBox(width: 8),
                  _buildDropdown(
                    l10n.communityFilterGender,
                    gender,
                    ['M', 'F', 'Mixed'],
                    (v) => setState(() => gender = v),
                    displayValues: [
                      l10n.communityFilterOptionM,
                      l10n.communityFilterOptionF,
                      l10n.communityFilterOptionMixed,
                    ],
                  ),
                ],
              ),
            ),
            // League info
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: getLeagueGradient(),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.communityLeagueLabel(l10n.leagueDisplay(league)),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.communityLeagueInfo,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLeagueSelector('Bronze', Color(0xFFEF8D31)),
                      _buildLeagueSelector('Silver', Color(0xFFA7B5C0)),
                      _buildLeagueSelector('Gold', Color(0xFFF6C619)),
                    ],
                  ),
                ],
              ),
            ),
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
                  const SizedBox(width: 48),
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
            if (filteredUsers.isEmpty)
              SizedBox(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      l10n.communityNoUsersFilters,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
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
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String> onChanged, {
    List<String>? displayValues,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items: List.generate(
            options.length,
            (i) => DropdownMenuItem(
              value: options[i],
              child: Text(
                displayValues != null ? displayValues[i] : options[i],
              ),
            ),
          ),
          onChanged: (v) => v != null ? onChanged(v) : null,
          style: const TextStyle(color: Colors.black),
          dropdownColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLeagueSelector(String label, Color color) {
    final selected = league == label;
    return GestureDetector(
      onTap: () => setState(() => league = label),
      child: Transform.rotate(
        angle: 0.79, // ~45 degrees
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: selected ? 40 : 24,
          height: selected ? 40 : 24,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(selected ? 12 : 4),
            border: selected ? Border.all(color: Colors.white, width: 3) : null,
          ),
        ),
      ),
    );
  }
}

extension LocalCommunityTabL10n on AppLocalizations {
  String leagueDisplay(String league) {
    switch (league) {
      case 'Bronze':
        return communityLeagueBronze;
      case 'Silver':
        return communityLeagueSilver;
      case 'Gold':
        return communityLeagueGold;
      default:
        return league;
    }
  }
}

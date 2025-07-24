import 'package:flutter/material.dart';
import '../../b4s_colors.dart';

class LocalCommunityTab extends StatefulWidget {
  const LocalCommunityTab({super.key});

  @override
  State<LocalCommunityTab> createState() => _LocalCommunityTabState();
}

class _LocalCommunityTabState extends State<LocalCommunityTab> {
  // Mock filter state
  String stage = 'Benjamin';
  String category = 'Todas';
  String gender = 'Mixto';
  String league = 'Bronce';

  // Mock user data
  final List<Map<String, dynamic>> allUsers = [
    // 40 mock users for demo
    {
      'name': 'Paul C. Ramos',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 5075,
      'isCurrent': true,
      'stage': 'Benjamin',
      'category': 'A',
      'gender': 'M',
      'league': 'Bronce',
    },
    {
      'name': 'Derrick L. Thoman',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 4985,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'B',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Kelsey T. Donovan',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 4642,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Jack L. Gregory',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3874,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'C',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'Mary R. Mercado',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3567,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Theresa N. Maki',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3478,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'B',
      'gender': 'F',
      'league': 'Plata',
    },
    {
      'name': 'James R. Stokes',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3257,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'C',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'David B. Rodriguez',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3250,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'B',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Annette R. Allen',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3212,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Lucas M. White',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3100,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronce',
    },
    {
      'name': 'Sophie L. Turner',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3050,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Plata',
    },
    {
      'name': 'Carlos G. Perez',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2990,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'Emma S. Clark',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2950,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Noah J. Lee',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2900,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Olivia K. Adams',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2850,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Oro',
    },
    {
      'name': 'Mason D. Evans',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2800,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronce',
    },
    {
      'name': 'Ava F. Scott',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2750,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Plata',
    },
    {
      'name': 'Ethan H. King',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2700,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'Mia I. Wright',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2650,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Logan J. Baker',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2600,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Ella K. Nelson',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2550,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Oro',
    },
    {
      'name': 'Jacob L. Carter',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2500,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronce',
    },
    {
      'name': 'Charlotte M. Mitchell',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2450,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Plata',
    },
    {
      'name': 'William N. Perez',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2400,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'Amelia O. Roberts',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2350,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Henry P. Murphy',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2300,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Grace Q. Foster',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2250,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Oro',
    },
    {
      'name': 'Benjamin R. Bell',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2200,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronce',
    },
    {
      'name': 'Zoe S. Cooper',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2150,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Plata',
    },
    {
      'name': 'Alexander T. Ward',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2100,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'Lily U. Morgan',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2050,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Samuel V. Reed',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2000,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Chloe W. Bailey',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1950,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Oro',
    },
    {
      'name': 'Matthew X. Rivera',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1900,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronce',
    },
    {
      'name': 'Scarlett Y. Kim',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1850,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Plata',
    },
    {
      'name': 'Daniel Z. Cox',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1800,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'Victoria A. Brooks',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1750,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Jackson B. Sanders',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1700,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Penelope C. Price',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1650,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Oro',
    },
    {
      'name': 'Sebastian D. Bennett',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1600,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronce',
    },
    {
      'name': 'Layla E. Barnes',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1550,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Plata',
    },
    {
      'name': 'Aiden F. Ross',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1500,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'Hannah G. Henderson',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1450,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Lucas H. Bryant',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1400,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Mila I. Griffin',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1350,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Oro',
    },
    {
      'name': 'Elijah J. Russell',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1300,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronce',
    },
    {
      'name': 'Aria K. Hayes',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1250,
      'isCurrent': false,
      'stage': 'Alevin',
      'category': 'C',
      'gender': 'F',
      'league': 'Plata',
    },
    {
      'name': 'Logan L. Patterson',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1200,
      'isCurrent': false,
      'stage': 'Cadete',
      'category': 'A',
      'gender': 'M',
      'league': 'Oro',
    },
    {
      'name': 'Sofia M. Simmons',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1150,
      'isCurrent': false,
      'stage': 'Infantil',
      'category': 'B',
      'gender': 'F',
      'league': 'Bronce',
    },
    {
      'name': 'Mason N. Alexander',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1100,
      'isCurrent': false,
      'stage': 'Juvenil',
      'category': 'C',
      'gender': 'M',
      'league': 'Plata',
    },
    {
      'name': 'Camila O. Griffin',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1050,
      'isCurrent': false,
      'stage': 'Amateur',
      'category': 'A',
      'gender': 'F',
      'league': 'Oro',
    },
    {
      'name': 'Oliver P. Ford',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 1000,
      'isCurrent': false,
      'stage': 'Benjamin',
      'category': 'B',
      'gender': 'M',
      'league': 'Bronce',
    },
  ];

  List<Map<String, dynamic>> get filteredUsers {
    return allUsers.where((user) {
        final stageMatch = (stage == 'Todas' || user['stage'] == stage);
        final categoryMatch =
            (category == 'Todas' ||
                category == 'Ninguno' ||
                user['category'] == category);
        final genderMatch = (gender == 'Mixto' || user['gender'] == gender);
        final leagueMatch = (league == '' || user['league'] == league);
        return stageMatch && categoryMatch && genderMatch && leagueMatch;
      }).toList()
      ..sort((a, b) => b['points'].compareTo(a['points']));
  }

  // League colors
  LinearGradient getLeagueGradient() {
    switch (league) {
      case 'Bronce':
        return const LinearGradient(
          colors: [Color(0xFFEF8D31), Color(0x00EF8D31)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Plata':
        return const LinearGradient(
          colors: [Color(0xFFA7B5C0), Color(0x007B7B7B)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case 'Oro':
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
                  _buildDropdown('Etapa', stage, [
                    'Benjamin',
                    'Alevin',
                    'Cadete',
                    'Infantil',
                    'Juvenil',
                    'Amateur',
                    'Todas',
                  ], (v) => setState(() => stage = v)),
                  const SizedBox(width: 8),
                  _buildDropdown('Categoria', category, [
                    'Ninguno',
                    'A',
                    'B',
                    'C',
                    'Todas',
                  ], (v) => setState(() => category = v)),
                  const SizedBox(width: 8),
                  _buildDropdown('Género', gender, [
                    'M',
                    'F',
                    'Mixto',
                  ], (v) => setState(() => gender = v)),
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
                    'Liga $league',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Los top 3, al finalizar la semana, avanzan a la siguiente liga',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLeagueSelector('Bronce', Color(0xFFEF8D31)),
                      _buildLeagueSelector('Plata', Color(0xFFA7B5C0)),
                      _buildLeagueSelector('Oro', Color(0xFFF6C619)),
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
                children: const [
                  SizedBox(
                    width: 24,
                    child: Text('#', style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      'Deportista',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text('Puntos', style: TextStyle(color: Colors.white)),
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
                      'No users found for the selected filters.',
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
                        backgroundImage: AssetImage(user['avatar']),
                        backgroundColor: Colors.white,
                      ),
                      title: Text(
                        user['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle:
                          isCurrent
                              ? const Text(
                                'Tú',
                                style: TextStyle(color: Colors.white70),
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
    ValueChanged<String> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          items:
              options
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
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

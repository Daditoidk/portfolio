import 'package:flutter/material.dart';
import '../../b4s_colors.dart';

class GlobalCommunityTab extends StatelessWidget {
  const GlobalCommunityTab({super.key});

  // Mock user data
  final List<Map<String, dynamic>> users = const [
    // 20 mock users for demo
    {
      'name': 'Paul C. Ramos',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 5075,
      'isCurrent': true,
    },
    {
      'name': 'Derrick L. Thoman',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 4985,
      'isCurrent': false,
    },
    {
      'name': 'Kelsey T. Donovan',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 4642,
      'isCurrent': false,
    },
    {
      'name': 'Jack L. Gregory',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3874,
      'isCurrent': false,
    },
    {
      'name': 'Mary R. Mercado',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3567,
      'isCurrent': false,
    },
    {
      'name': 'Theresa N. Maki',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3478,
      'isCurrent': false,
    },
    {
      'name': 'James R. Stokes',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3257,
      'isCurrent': false,
    },
    {
      'name': 'David B. Rodriguez',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3250,
      'isCurrent': false,
    },
    {
      'name': 'Annette R. Allen',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3212,
      'isCurrent': false,
    },
    {
      'name': 'Lucas M. White',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3100,
      'isCurrent': false,
    },
    {
      'name': 'Sophie L. Turner',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 3050,
      'isCurrent': false,
    },
    {
      'name': 'Carlos G. Perez',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2990,
      'isCurrent': false,
    },
    {
      'name': 'Emma S. Clark',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2950,
      'isCurrent': false,
    },
    {
      'name': 'Noah J. Lee',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2900,
      'isCurrent': false,
    },
    {
      'name': 'Olivia K. Adams',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2850,
      'isCurrent': false,
    },
    {
      'name': 'Mason D. Evans',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2800,
      'isCurrent': false,
    },
    {
      'name': 'Ava F. Scott',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2750,
      'isCurrent': false,
    },
    {
      'name': 'Ethan H. King',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2700,
      'isCurrent': false,
    },
    {
      'name': 'Mia I. Wright',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2650,
      'isCurrent': false,
    },
    {
      'name': 'Logan J. Baker',
      'avatar': 'assets/demos/b4s/avatar.jpg',
      'points': 2600,
      'isCurrent': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff1F2022),
      child: Column(
        children: [
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
          Expanded(
            child:
                users.isEmpty
                    ? SizedBox(
                      height: 200,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'No users found for the global leaderboard.',
                            style: TextStyle(
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
                              backgroundImage: AssetImage(user['avatar']),
                              backgroundColor: Colors.white,
                              child: Text(
                                (index + 1).toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
          ),
        ],
      ),
    );
  }
}

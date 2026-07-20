import 'package:flutter/material.dart';
import 'chat_screen.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  Widget buildFriendTile(
    BuildContext context, {
    required String name,
    required String subtitle,
    required Color color,
    required bool online,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: CircleAvatar(
                radius: 6,
                backgroundColor: online ? Colors.lightGreenAccent : Colors.grey,
              ),
            ),
          ],
        ),
        title: Text(
          name,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatScreen(friendName: name),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
          ),
          child: const Text('Message'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final friends = [
      {'name': 'Musa', 'subtitle': 'Online now', 'color': Colors.purple, 'online': true},
      {'name': 'My Baby', 'subtitle': 'In room', 'color': Colors.pink, 'online': true},
      {'name': 'Z A N', 'subtitle': 'Last seen 2m ago', 'color': Colors.blue, 'online': false},
      {'name': 'Zary', 'subtitle': 'Online now', 'color': Colors.green, 'online': true},
      {'name': 'Sher', 'subtitle': 'In match', 'color': Colors.orange, 'online': true},
      {'name': 'Skif', 'subtitle': 'Offline', 'color': Colors.red, 'online': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        backgroundColor: const Color(0xFF0C7D68),
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF12B886),
              Color(0xFF0E8F74),
              Color(0xFF0A6A5D),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return buildFriendTile(
              context,
              name: friend['name'] as String,
              subtitle: friend['subtitle'] as String,
              color: friend['color'] as Color,
              online: friend['online'] as bool,
            );
          },
        ),
      ),
    );
  }
}

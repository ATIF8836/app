import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget statCard(String title, String value, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.14),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTile(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade700,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white70,
          size: 18,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: const Color(0xFF0C7D68),
        foregroundColor: Colors.white,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF12B886), Color(0xFF0E8F74), Color(0xFF0A6A5D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 42,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 46, color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'Royal Level 1',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Player ID: 406842367290',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  statCard('Games', '5688', Icons.sports_esports),
                  statCard('Win Rate', '52.6%', Icons.trending_up),
                ],
              ),
              Row(
                children: [
                  statCard('League', 'Current', Icons.shield),
                  statCard('Badges', '4', Icons.military_tech),
                ],
              ),
              const SizedBox(height: 12),
              sectionTile(
                'Achievements',
                'View your progress and milestones',
                Icons.emoji_events,
              ),
              sectionTile(
                'Favorite Dice',
                'Manage selected dice skins',
                Icons.casino,
              ),
              sectionTile(
                'Profile Frame',
                'Customize profile style',
                Icons.crop_square_rounded,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

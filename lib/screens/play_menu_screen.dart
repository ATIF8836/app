import 'package:flutter/material.dart';
import 'join_room_screen.dart';

class PlayMenuScreen extends StatelessWidget {
  const PlayMenuScreen({super.key});

  Widget _menuCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white.withOpacity(0.12),
              border: Border.all(color: Colors.white24),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: color,
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white70,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Play Menu'),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _menuCard(
                context: context,
                title: 'Create Room',
                subtitle: 'Start a private match and invite friends',
                icon: Icons.add_home_work_outlined,
                color: Colors.orange,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JoinRoomScreen(isCreating: true),
                    ),
                  );
                },
              ),
              _menuCard(
                context: context,
                title: 'Join Room',
                subtitle: 'Enter room code and join an active lobby',
                icon: Icons.meeting_room_outlined,
                color: Colors.lightBlue,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const JoinRoomScreen(isCreating: false),
                    ),
                  );
                },
              ),
              _menuCard(
                context: context,
                title: 'Quick Match',
                subtitle: 'Auto-match feature for future update',
                icon: Icons.flash_on,
                color: Colors.purple,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Quick Match coming next')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

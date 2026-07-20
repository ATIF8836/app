import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool sound = true;
  bool music = true;

  Widget settingTile({
    required String title,
    Widget? trailing,
    IconData? icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: ListTile(
        leading: icon != null
            ? CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(icon, color: Colors.white),
              )
            : null,
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: trailing,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
              settingTile(
                title: 'Support',
                icon: Icons.help_outline,
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
              settingTile(
                title: 'Share',
                icon: Icons.share,
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
              settingTile(
                title: 'Mail',
                icon: Icons.mail_outline,
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white70,
                  size: 18,
                ),
              ),
              settingTile(
                title: 'Sound',
                icon: Icons.volume_up,
                trailing: Switch(
                  value: sound,
                  onChanged: (value) {
                    setState(() => sound = value);
                  },
                ),
              ),
              settingTile(
                title: 'Music',
                icon: Icons.music_note,
                trailing: Switch(
                  value: music,
                  onChanged: (value) {
                    setState(() => music = value);
                  },
                ),
              ),
              settingTile(
                title: 'Language',
                icon: Icons.language,
                trailing: const Text(
                  'English',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    'Log Out',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

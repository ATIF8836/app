import 'package:flutter/material.dart';
import 'theme_screen.dart';
import 'dice_screen.dart';
import 'token_screen.dart';

class CosmeticsHomeScreen extends StatelessWidget {
  const CosmeticsHomeScreen({super.key});

  Widget buildButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget screen,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF16C79A),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
          },
          icon: Icon(icon),
          label: Text(title),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F8F7A),
      appBar: AppBar(
        title: const Text('Cosmetics'),
        backgroundColor: const Color(0xFF13B58F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            buildButton(
              context,
              title: 'Themes',
              icon: Icons.palette,
              screen: const ThemeScreen(),
            ),
            buildButton(
              context,
              title: 'Dice',
              icon: Icons.casino,
              screen: const DiceScreen(),
            ),
            buildButton(
              context,
              title: 'Tokens',
              icon: Icons.circle,
              screen: const TokenScreen(),
            ),
          ],
        ),
      ),
    );
  }
}

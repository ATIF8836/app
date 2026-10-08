import 'package:flutter/material.dart';
import '../../data/game_themes.dart';
import '../../services/cosmetics_services.dart';
import '../../widgets/cosmetic_card.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});

  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  @override
  Widget build(BuildContext context) {
    final service = CosmeticsService();

    return Scaffold(
      backgroundColor: const Color(0xFF0F8F7A),
      appBar: AppBar(
        title: const Text('Themes'),
        backgroundColor: const Color(0xFF13B58F),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: gameThemes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.78,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final item = gameThemes[index];
          return CosmeticCard(
            title: item.name,
            subtitle: item.id,
            selected: service.equippedThemeId == item.id,
            preview: Container(
              width: 90,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: item.backgroundColors.map((e) => Color(e)).toList(),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                border: Border.all(color: Colors.white70),
              ),
              child: Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Color(item.frameStartColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.grid_on, color: Colors.white),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                service.equipTheme(item.id);
              });
            },
          );
        },
      ),
    );
  }
}

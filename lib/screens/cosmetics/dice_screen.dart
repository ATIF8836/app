import 'package:flutter/material.dart';
import '../../data/dice_skins.dart';
import '../../services/cosmetics_services.dart';
import '../../widgets/cosmetic_card.dart';

class DiceScreen extends StatefulWidget {
  const DiceScreen({super.key});

  @override
  State<DiceScreen> createState() => _DiceScreenState();
}

class _DiceScreenState extends State<DiceScreen> {
  @override
  Widget build(BuildContext context) {
    final service = CosmeticsService();

    return Scaffold(
      backgroundColor: const Color(0xFF0F8F7A),
      appBar: AppBar(
        title: const Text('Dice'),
        backgroundColor: const Color(0xFF13B58F),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: diceSkins.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.82,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final item = diceSkins[index];
          return CosmeticCard(
            title: item.name,
            subtitle: item.id,
            selected: service.equippedDiceId == item.id,
            preview: Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: Color(item.bgColor),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white70),
              ),
              child: Center(
                child: Icon(
                  Icons.casino,
                  color: Color(item.dotColor),
                  size: 40,
                ),
              ),
            ),
            onTap: () {
              setState(() {
                service.equipDice(item.id);
              });
            },
          );
        },
      ),
    );
  }
}

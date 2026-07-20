import 'package:flutter/material.dart';
import '../../data/token_skins.dart';
import '../../services/cosmetics_services.dart';
import '../../widgets/cosmetic_card.dart';

class TokenScreen extends StatefulWidget {
  const TokenScreen({super.key});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  @override
  Widget build(BuildContext context) {
    final service = CosmeticsService();

    return Scaffold(
      backgroundColor: const Color(0xFF0F8F7A),
      appBar: AppBar(
        title: const Text('Tokens'),
        backgroundColor: const Color(0xFF13B58F),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tokenSkins.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.82,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (_, index) {
          final item = tokenSkins[index];
          return CosmeticCard(
            title: item.name,
            subtitle: item.id,
            selected: service.equippedTokenId == item.id,
            preview: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(
                4,
                (_) => Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(item.accentColor),
                    border: Border.all(color: Colors.white, width: 1.2),
                  ),
                ),
              ),
            ),
            onTap: () {
              setState(() {
                service.equipToken(item.id);
              });
            },
          );
        },
      ),
    );
  }
}

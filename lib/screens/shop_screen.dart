import 'package:flutter/material.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  Widget buildPack({
    required String title,
    required String coins,
    required String price,
    required List<Color> colors,
    String? badge,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.monetization_on, color: Colors.amber, size: 34),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (badge != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  coins,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            ),
            child: Text(price),
          ),
        ],
      ),
    );
  }

  Widget buildBanner(String title, String subtitle, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.amber.shade700,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
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
          const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 18),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
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
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            buildBanner('Super Value Vaults', 'Get more value from limited-time bundles', Icons.savings),
            buildBanner('Master Archer', 'Special event packs and collectibles', Icons.gavel),
            buildPack(
              title: 'Starter Pack',
              coins: '35.0K Coins',
              price: 'USD 0.99',
              colors: const [Color(0xFF26C6DA), Color(0xFF00838F)],
            ),
            buildPack(
              title: 'Growth Pack',
              coins: '150.0K Coins',
              price: 'USD 2.99',
              colors: const [Color(0xFF66BB6A), Color(0xFF2E7D32)],
            ),
            buildPack(
              title: 'Popular Pack',
              coins: '570.0K Coins',
              price: 'USD 8.99',
              colors: const [Color(0xFFFFB74D), Color(0xFFF57C00)],
              badge: 'Popular',
            ),
            buildPack(
              title: 'Best Pack',
              coins: '17.0M Coins',
              price: 'USD 69.99',
              colors: const [Color(0xFFF06292), Color(0xFFD81B60)],
              badge: 'Best',
            ),
          ],
        ),
      ),
    );
  }
}

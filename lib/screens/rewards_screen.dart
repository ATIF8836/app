import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  Widget rewardBanner(
    String title,
    String subtitle,
    IconData icon,
    List<Color> colors,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.white.withOpacity(0.18),
            child: Icon(icon, color: Colors.white, size: 26),
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
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
            ),
            child: const Text('Collect'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards'),
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
              rewardBanner(
                'Free Rewards',
                'Collect your daily bonus and surprise gifts',
                Icons.card_giftcard,
                const [Color(0xFF66BB6A), Color(0xFF2E7D32)],
              ),
              rewardBanner(
                'Gold Chest',
                'Open chest for coins and collectibles',
                Icons.inventory_2,
                const [Color(0xFFFFCA28), Color(0xFFFF8F00)],
              ),
              rewardBanner(
                'Reward Tower',
                'Climb the reward ladder and unlock more',
                Icons.stacked_bar_chart,
                const [Color(0xFF42A5F5), Color(0xFF1565C0)],
              ),
              rewardBanner(
                'Super Value Vaults',
                'Limited-time bundles and reward packs',
                Icons.savings,
                const [Color(0xFF26C6DA), Color(0xFF00838F)],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

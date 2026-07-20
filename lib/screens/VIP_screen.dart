import 'package:flutter/material.dart';

class VipScreen extends StatelessWidget {
  const VipScreen({super.key});

  Widget benefitTile(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      ),
    );
  }

  Widget packageCard(String coins, String price, {String? badge}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF43C6AC), Color(0xFF1B9AAA)],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white24),
        ),
        child: Column(
          children: [
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                margin: const EdgeInsets.only(bottom: 8),
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
            const Icon(Icons.monetization_on, color: Colors.amber, size: 32),
            const SizedBox(height: 8),
            Text(
              coins,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIP'),
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
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.workspace_premium,
                      color: Colors.amber.shade700,
                      size: 54,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Royal Level 1',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: 0.12,
                      backgroundColor: Colors.white24,
                      color: Colors.amber,
                      minHeight: 10,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '40 / 35000',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              benefitTile(
                Icons.badge,
                'VIP Badge',
                'Exclusive logo and display',
              ),
              benefitTile(Icons.meeting_room, 'VIP Room', 'Join special rooms'),
              benefitTile(
                Icons.card_giftcard,
                'Daily Benefits',
                'Claim daily rewards',
              ),
              benefitTile(
                Icons.vertical_align_top,
                'Sticky on Top',
                'Priority display in room',
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  packageCard('35.0K', 'USD 0.99'),
                  packageCard('150.0K', 'USD 2.99'),
                  packageCard('570.0K', 'USD 8.99', badge: 'Popular'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

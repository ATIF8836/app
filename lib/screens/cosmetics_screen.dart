import 'package:flutter/material.dart';

class CosmeticsScreen extends StatefulWidget {
  const CosmeticsScreen({super.key});

  @override
  State<CosmeticsScreen> createState() => _CosmeticsScreenState();
}

class _CosmeticsScreenState extends State<CosmeticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  String selectedTheme = 'Classic';
  String selectedDice = 'Golden Dice';
  String selectedFrame = 'Royal Frame';

  final List<Map<String, dynamic>> themes = [
    {'name': 'Classic', 'icon': Icons.palette, 'color': Colors.orange},
    {'name': 'Ocean', 'icon': Icons.water_drop, 'color': Colors.blue},
    {'name': 'Forest', 'icon': Icons.park, 'color': Colors.green},
    {'name': 'Royal', 'icon': Icons.workspace_premium, 'color': Colors.purple},
  ];

  final List<Map<String, dynamic>> diceSkins = [
    {'name': 'Golden Dice', 'icon': Icons.casino, 'color': Colors.amber},
    {'name': 'Ruby Dice', 'icon': Icons.casino, 'color': Colors.red},
    {'name': 'Emerald Dice', 'icon': Icons.casino, 'color': Colors.green},
    {'name': 'Ice Dice', 'icon': Icons.casino, 'color': Colors.lightBlue},
  ];

  final List<Map<String, dynamic>> frames = [
    {'name': 'Royal Frame', 'icon': Icons.crop_square, 'color': Colors.amber},
    {'name': 'Knight Frame', 'icon': Icons.shield, 'color': Colors.blueGrey},
    {'name': 'Baron Frame', 'icon': Icons.diamond, 'color': Colors.deepPurple},
    {'name': 'Champion Frame', 'icon': Icons.emoji_events, 'color': Colors.orange},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget buildItemCard({
    required String name,
    required IconData icon,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withOpacity(0.95),
              color.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? Colors.amberAccent : Colors.white24,
            width: selected ? 3 : 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: Colors.white),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (selected)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Equipped',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildGrid(
    List<Map<String, dynamic>> items,
    String selectedValue,
    void Function(String) onSelect,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return buildItemCard(
          name: item['name'],
          icon: item['icon'],
          color: item['color'],
          selected: selectedValue == item['name'],
          onTap: () {
            setState(() {
              onSelect(item['name']);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cosmetics'),
        backgroundColor: const Color(0xFF0C7D68),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.amber,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Themes'),
            Tab(text: 'Dice'),
            Tab(text: 'Frames'),
          ],
        ),
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
        child: TabBarView(
          controller: _tabController,
          children: [
            buildGrid(themes, selectedTheme, (value) => selectedTheme = value),
            buildGrid(diceSkins, selectedDice, (value) => selectedDice = value),
            buildGrid(frames, selectedFrame, (value) => selectedFrame = value),
          ],
        ),
      ),
    );
  }
}

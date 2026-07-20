import 'dart:math';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String roomCode;
  final List<dynamic> players;

  const GameScreen({super.key, required this.roomCode, required this.players});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  int diceValue = 1;
  final Random random = Random();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 1,
      end: 1.12,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void rollDice() {
    setState(() {
      diceValue = random.nextInt(6) + 1;
    });
    _controller.forward(from: 0);
  }

  Widget buildPlayerChip(String name, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: color,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBoardCell(Color color, {Widget? child}) {
    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black12),
      ),
      child: child,
    );
  }

  Widget buildLudoBoard() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFDDA15E),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 225,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 15,
          ),
          itemBuilder: (context, index) {
            final row = index ~/ 15;
            final col = index % 15;

            Color cellColor = Colors.white;

            if (row < 6 && col < 6) cellColor = Colors.red.shade100;
            if (row < 6 && col > 8) cellColor = Colors.green.shade100;
            if (row > 8 && col < 6) cellColor = Colors.blue.shade100;
            if (row > 8 && col > 8) cellColor = Colors.yellow.shade100;

            if (row == 6 && col >= 1 && col <= 5) {
              cellColor = Colors.red.shade300;
            }
            if (row >= 1 && row <= 5 && col == 8) {
              cellColor = Colors.green.shade300;
            }
            if (row == 8 && col >= 9 && col <= 13) {
              cellColor = Colors.yellow.shade700;
            }
            if (row >= 9 && row <= 13 && col == 6) {
              cellColor = Colors.blue.shade300;
            }

            if ((row == 7 && col == 7)) {
              return buildBoardCell(
                Colors.orange.shade400,
                child: const Center(
                  child: Icon(Icons.star, color: Colors.white, size: 18),
                ),
              );
            }

            return buildBoardCell(cellColor);
          },
        ),
      ),
    );
  }

  Widget buildDice() {
    return GestureDetector(
      onTap: rollDice,
      child: ScaleTransition(
        scale: _animation,
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              '$diceValue',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final names = widget.players
        .map((e) => e['name']?.toString() ?? 'Player')
        .toList();
    final colors = [
      Colors.red,
      Colors.green,
      Colors.yellow.shade800,
      Colors.blue,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Game Room • ${widget.roomCode}'),
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
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              SizedBox(
                height: 56,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: names.length,
                  itemBuilder: (context, index) {
                    return buildPlayerChip(
                      names[index],
                      colors[index % colors.length],
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: buildLudoBoard(),
              ),
              const SizedBox(height: 18),
              const Text(
                'Tap dice to roll',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              buildDice(),
            ],
          ),
        ),
      ),
    );
  }
}

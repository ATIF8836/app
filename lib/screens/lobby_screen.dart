import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import 'game_screen.dart';

class LobbyScreen extends StatefulWidget {
  final String roomCode;
  final List<dynamic> players;
  final bool isHost;

  const LobbyScreen({
    super.key,
    required this.roomCode,
    required this.players,
    required this.isHost,
  });

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
  late List<dynamic> players;

  @override
  void initState() {
    super.initState();
    players = List.from(widget.players);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerSocketListeners();
    });
  }

  void _registerSocketListeners() {
    final socket = SocketService().socket;

    if (socket == null) {
      print('Socket is null in lobby');
      return;
    }

    print('Registering lobby socket listeners');

    socket.off('room_joined');
    socket.on('room_joined', (data) {
      print('Lobby got room_joined: $data');
      if (!mounted) return;
      if (data['roomCode'] == widget.roomCode) {
        setState(() {
          players = List.from(data['players'] ?? []);
        });
      }
    });

    socket.off('game_started');
    socket.on('game_started', (data) {
      print('game_started received in lobby: $data');
      if (!mounted) return;

      final roomPlayers = List<dynamic>.from(data['players'] ?? []);
      final roomCode = data['roomCode'] ?? widget.roomCode;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(roomCode: roomCode, players: roomPlayers),
        ),
      );
    });

    socket.off('error_message');
    socket.on('error_message', (data) {
      print('Lobby got error_message: $data');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Something went wrong')),
      );
    });
  }

  @override
  void dispose() {
    final socket = SocketService().socket;
    socket?.off('room_joined');
    socket?.off('game_started');
    socket?.off('error_message');
    super.dispose();
  }

  void startGame() {
    final socket = SocketService().socket;

    print('Lobby startGame pressed');
    print('Lobby socket connected: ${socket?.connected}');
    print('Lobby room code: ${widget.roomCode}');
    print('Lobby socket id: ${socket?.id}');

    if (socket == null || socket.connected != true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not connected to server')));
      return;
    }

    socket.emit('start_game', {'roomId': widget.roomCode});
    print('start_game emitted for room: ${widget.roomCode}');
  }

  Widget _buildPlayerCard(dynamic player, int index) {
    final colors = [
      Colors.red.shade400,
      Colors.green.shade500,
      Colors.amber.shade700,
      Colors.blue.shade400,
    ];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 4,
      color: Colors.white.withOpacity(0.96),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors[index % colors.length],
          child: Text(
            '${index + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          player['name'] ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          player['id'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11),
        ),
        trailing: index == 0
            ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange),
                ),
                child: const Text(
                  'Host',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canStartGame = players.length >= 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Room Lobby'),
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Room Code',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.roomCode,
                        style: const TextStyle(
                          fontSize: 30,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.isHost
                          ? 'You are the host. Start when everyone is ready.'
                          : 'Waiting for host to start the match.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Text(
                    'Players',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${players.length}/4',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: players.isEmpty
                    ? const Center(
                        child: Text(
                          'Waiting for players...',
                          style: TextStyle(color: Colors.white70),
                        ),
                      )
                    : ListView.builder(
                        itemCount: players.length,
                        itemBuilder: (context, index) {
                          return _buildPlayerCard(players[index], index);
                        },
                      ),
              ),
              const SizedBox(height: 10),
              if (widget.isHost)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canStartGame ? startGame : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      canStartGame ? 'Start Game' : 'Need at least 2 players',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Center(
                    child: Text(
                      'Waiting for host to start...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

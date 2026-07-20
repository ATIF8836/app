import 'package:flutter/material.dart';
import '../services/socket_service.dart';
import 'lobby_screen.dart';

class JoinRoomScreen extends StatefulWidget {
  final bool isCreating;

  const JoinRoomScreen({super.key, required this.isCreating});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController roomController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();

    final socket = SocketService().socket;

    socket?.off('room_created');
    socket?.on('room_created', (data) {
      print('Flutter got room_created: $data');

      if (!mounted) return;

      setState(() => loading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LobbyScreen(
            roomCode: data['roomCode'],
            players: List<dynamic>.from(data['players'] ?? []),
            isHost: true,
          ),
        ),
      );
    });

    socket?.off('room_joined');
    socket?.on('room_joined', (data) {
      print('Flutter got room_joined: $data');

      if (!mounted) return;

      setState(() => loading = false);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LobbyScreen(
            roomCode: data['roomCode'],
            players: List<dynamic>.from(data['players'] ?? []),
            isHost: false,
          ),
        ),
      );
    });

    socket?.off('error_message');
    socket?.on('error_message', (data) {
      print('Flutter got error_message: $data');

      if (!mounted) return;

      setState(() => loading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Something went wrong')),
      );
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    roomController.dispose();
    super.dispose();
  }

  void submit() {
    final name = nameController.text.trim();
    final room = roomController.text.trim().toUpperCase();
    final socket = SocketService().socket;

    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter your name')));
      return;
    }

    if (!widget.isCreating && room.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter room code')));
      return;
    }

    if (socket == null || socket.connected != true) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not connected to server')));
      return;
    }

    setState(() => loading = true);

    if (widget.isCreating) {
      print('Create button clicked with name: $name');
      socket.emit('create_room', {'name': name});
      print('create_room emitted');
    } else {
      print('Join button clicked with name: $name and room: $room');
      socket.emit('join_room', {'name': name, 'roomId': room});
      print('join_room emitted');
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      prefixIcon: Icon(icon),
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isCreating ? 'Create Room' : 'Join Room';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(
                      widget.isCreating
                          ? Icons.add_home_work_outlined
                          : Icons.meeting_room_outlined,
                      color: Colors.white,
                      size: 54,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.isCreating
                          ? 'Start a room and invite your friends'
                          : 'Enter your name and room code to join',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: nameController,
                      decoration: _inputDecoration('Your Name', Icons.person),
                    ),
                    const SizedBox(height: 14),
                    if (!widget.isCreating)
                      TextField(
                        controller: roomController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: _inputDecoration(
                          'Room Code',
                          Icons.confirmation_number,
                        ),
                      ),
                    if (!widget.isCreating) const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          loading
                              ? 'Please wait...'
                              : (widget.isCreating
                                    ? 'Create Room'
                                    : 'Join Room'),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String friendName;

  const ChatScreen({
    super.key,
    required this.friendName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {'text': 'Hey, join my room!', 'me': false},
    {'text': 'Send code', 'me': true},
    {'text': 'LIOVND', 'me': false},
  ];

  void sendMessage() {
    final text = controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      messages.add({'text': text, 'me': true});
    });

    controller.clear();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildMessageBubble(String text, bool me) {
    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: me ? Colors.orange : Colors.white.withOpacity(0.16),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.friendName),
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
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  return buildMessageBubble(
                    msg['text'] as String,
                    msg['me'] as bool,
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.black.withOpacity(0.12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type message...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: IconButton(
                      onPressed: sendMessage,
                      icon: const Icon(Icons.send, color: Colors.white),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

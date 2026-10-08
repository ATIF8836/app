import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../services/voice_service.dart';

/// A row of player seats for a room's voice chat, plus a join/leave/mute
/// control. Voice itself runs through [VoiceService] (Agora); this widget
/// only adds the small bit of glue needed to label who's who — it relays
/// each person's Agora uid to the rest of the room over the existing
/// Socket.io connection so seats can show names instead of raw numbers.
class VoiceSeatsBar extends StatefulWidget {
  final String roomCode;
  final List<dynamic> players; // [{id, name}, ...] — same shape as the lobby
  final String mySocketId;
  final IO.Socket? socket;

  const VoiceSeatsBar({
    super.key,
    required this.roomCode,
    required this.players,
    required this.mySocketId,
    required this.socket,
  });

  @override
  State<VoiceSeatsBar> createState() => _VoiceSeatsBarState();
}

class _VoiceSeatsBarState extends State<VoiceSeatsBar> {
  final VoiceService _voice = VoiceService();
  bool _connecting = false;

  // socketId -> agoraUid, so speaking indicators can be matched to names.
  final Map<String, int> _uidsBySocketId = {};

  @override
  void initState() {
    super.initState();
    widget.socket?.on('voice_uid_update', _onVoiceUidUpdate);
  }

  void _onVoiceUidUpdate(dynamic data) {
    final socketId = data['socketId'] as String?;
    final agoraUid = data['agoraUid'] as int?;
    if (socketId == null || agoraUid == null || !mounted) return;
    setState(() => _uidsBySocketId[socketId] = agoraUid);
  }

  Future<void> _toggleVoice() async {
    if (_voice.isJoined) {
      await _voice.leaveChannel();
      if (mounted) {
        setState(() => _uidsBySocketId.remove(widget.mySocketId));
      }
      return;
    }

    setState(() => _connecting = true);

    try {
      final uid = await _voice.joinChannel(widget.roomCode);
      widget.socket?.emit('voice_uid', {'agoraUid': uid});

      if (!mounted) return;
      setState(() {
        _uidsBySocketId[widget.mySocketId] = uid;
        _connecting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _connecting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Couldn\'t join voice: $e')),
      );
    }
  }

  Future<void> _toggleMute() async {
    await _voice.toggleMute();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    widget.socket?.off('voice_uid_update', _onVoiceUidUpdate);
    _voice.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Voice Chat',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 84,
          child: ValueListenableBuilder<Set<int>>(
            valueListenable: _voice.speakingUids,
            builder: (context, speaking, _) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.players.length,
                itemBuilder: (context, index) {
                  final player = widget.players[index];
                  final socketId = player['id']?.toString() ?? '';
                  final name = player['name']?.toString() ?? '?';
                  final agoraUid = _uidsBySocketId[socketId];
                  final isOnMic = agoraUid != null;
                  final isTalking = isOnMic && speaking.contains(agoraUid);
                  final isMe = socketId == widget.mySocketId;

                  return Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isTalking
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: isOnMic
                                ? const Color(0xFF0C7D68)
                                : Colors.white24,
                            child: Text(
                              name.isNotEmpty ? name[0].toUpperCase() : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 60,
                          child: Text(
                            isMe ? 'You' : name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: _connecting ? null : _toggleVoice,
              icon: Icon(_voice.isJoined ? Icons.call_end : Icons.mic),
              label: Text(
                _connecting
                    ? 'Connecting...'
                    : _voice.isJoined
                        ? 'Leave voice'
                        : 'Join voice',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _voice.isJoined ? Colors.red.shade400 : Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
            ),
            if (_voice.isJoined) ...[
              const SizedBox(width: 10),
              IconButton(
                onPressed: _toggleMute,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(_voice.isMuted ? Icons.mic_off : Icons.mic),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

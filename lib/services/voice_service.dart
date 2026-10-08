import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';

/// Wraps Agora's RTC engine so the rest of the app only has to deal with
/// "join this room's voice chat / leave / mute / who's talking".
class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  // DO: 2e585f8e59a34ac2bc6a1529bd7c2f28 (agora.io console -> Project Management).
  // Leaving the token empty below only works while the project is in
  // "App ID only" testing mode. Before a public launch, switch to
  // token-based auth (Agora's docs walk through this) so a stranger with
  // your App ID can't join your channels.
  static const String appId = '2e585f8e59a34ac2bc6a1529bd7c2f28';

  RtcEngine? _engine;
  int? localUid;
  bool isMuted = false;
  bool isJoined = false;

  /// Agora uids of everyone currently talking above the noise threshold
  /// (including the local user, uid 0 in the callback means "myself").
  final ValueNotifier<Set<int>> speakingUids = ValueNotifier<Set<int>>({});

  /// Agora uids of everyone currently connected to the voice channel.
  final ValueNotifier<Set<int>> joinedUids = ValueNotifier<Set<int>>({});

  Future<int> joinChannel(String channelName) async {
    if (isJoined) return localUid ?? 0;

    if (kIsWeb) {
      throw UnsupportedError('Voice chat is not supported in web browsers yet.');
    }

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(appId: appId));

    await _engine!.enableAudio();
    await _engine!.setChannelProfile(
      ChannelProfileType.channelProfileCommunication,
    );

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, uid) {
          isJoined = true;
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          joinedUids.value = {...joinedUids.value, remoteUid};
        },
        onUserOffline: (connection, remoteUid, reason) {
          joinedUids.value = {...joinedUids.value}..remove(remoteUid);
          speakingUids.value = {...speakingUids.value}..remove(remoteUid);
        },
        onAudioVolumeIndication:
            (connection, speakers, speakerNumber, totalVolume) {
          const noiseFloor = 5;
          final talking = speakers
              .where((s) => (s.volume ?? 0) > noiseFloor)
              .map((s) => s.uid ?? 0)
              .toSet();
          speakingUids.value = talking;
        },
      ),
    );

    await _engine!.enableAudioVolumeIndication(
      interval: 300,
      smooth: 3,
      reportVad: true,
    );

    // Random uid per session — good enough while everyone shares one App ID.
    final uid = Random().nextInt(900000) + 100000;

    await _engine!.joinChannel(
      token: '',
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        autoSubscribeAudio: true,
        publishMicrophoneTrack: true,
      ),
    );

    localUid = uid;
    joinedUids.value = {uid};
    return uid;
  }

  Future<void> leaveChannel() async {
    if (!isJoined && _engine == null) return;

    await _engine?.leaveChannel();
    await _engine?.release();

    _engine = null;
    isJoined = false;
    isMuted = false;
    localUid = null;
    joinedUids.value = {};
    speakingUids.value = {};
  }

  Future<void> toggleMute() async {
    isMuted = !isMuted;
    await _engine?.muteLocalAudioStream(isMuted);
  }
}

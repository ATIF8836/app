import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect() {
    if (socket != null && socket!.connected) return;

    socket = IO.io(
      'http://localhost:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('Socket connected: ${socket!.id}');
    });

    socket!.onConnectError((data) {
      print('Connect error -> $data');
    });

    socket!.onError((data) {
      print('Socket error -> $data');
    });

    socket!.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }
}

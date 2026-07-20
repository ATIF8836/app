import 'package:flutter/material.dart';
import 'services/socket_service.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SocketService().connect();
  runApp(const YelloLudoApp());
}

class YelloLudoApp extends StatelessWidget {
  const YelloLudoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yello Ludo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        scaffoldBackgroundColor: const Color(0xFF119E7E),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF12B886),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

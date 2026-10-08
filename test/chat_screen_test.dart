import 'package:app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('sending a message adds it to the chat list', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ChatScreen(friendName: 'Musa', roomCode: 'ABC123'),
      ),
    );

    await tester.enterText(find.byType(TextField), 'hello from test');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    expect(find.text('hello from test'), findsOneWidget);
  });
}

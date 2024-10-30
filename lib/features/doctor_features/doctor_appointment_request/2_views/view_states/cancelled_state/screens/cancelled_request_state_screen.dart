import 'package:flutter/material.dart';

class CancelledRequestStateScreenProvider extends StatelessWidget {
  const CancelledRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const CancelledRequestStateScreen();
  }
}

class CancelledRequestStateScreen extends StatelessWidget {
  const CancelledRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Cancelled Request'),
      ),
    );
  }
}

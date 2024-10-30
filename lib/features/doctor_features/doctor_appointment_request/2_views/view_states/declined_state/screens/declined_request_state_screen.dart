import 'package:flutter/material.dart';

class DeclinedRequestStateScreenProvider extends StatelessWidget {
  const DeclinedRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const DeclinedRequestStateScreen();
  }
}

class DeclinedRequestStateScreen extends StatelessWidget {
  const DeclinedRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Declined Request'),
      ),
    );
  }
}

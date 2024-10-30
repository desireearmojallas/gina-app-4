import 'package:flutter/material.dart';

class ApprovedRequestStateScreenProvider extends StatelessWidget {
  const ApprovedRequestStateScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return const ApprovedRequestStateScreen();
  }
}

class ApprovedRequestStateScreen extends StatelessWidget {
  const ApprovedRequestStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Approved Request'),
      ),
    );
  }
}

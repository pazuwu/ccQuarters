import 'package:flutter/material.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key, required this.login, required this.isFromSearch});

  final String login;
  final bool isFromSearch;

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Zaloguj się'),
    );
  }
}

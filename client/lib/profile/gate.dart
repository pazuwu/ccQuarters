import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/profile/profile.dart';
import 'package:ccquarters/profile/sign_in_widget.dart';
import 'package:flutter/material.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return user != null
        ? Profile(user: user!)
        : const SignInWidget();
  }
}
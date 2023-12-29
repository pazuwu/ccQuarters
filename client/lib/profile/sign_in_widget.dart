import 'package:ccquarters/login_register/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        child: const Text('Zaloguj się'),
        onPressed: () {
          context.read<AuthCubit>().signOut();
          context.go('/login');
        },
      ),
    );
  }
}

import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/common/views/sign_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequireSignIn extends StatelessWidget {
  const RequireSignIn({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return context.read<AuthCubit>().user != null
        ? child
        : const SignInWidget();
  }
}

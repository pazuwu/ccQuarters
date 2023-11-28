import 'package:ccquarters/login_register/states.dart';
import 'package:ccquarters/login_register/views/choose.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/views/login_register_view.dart';
import 'package:ccquarters/navigation_gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AuthCubit(
        authService: context.read(),
        userService: context.read(),
        houseService: context.read(),
        alertService: context.read(),
      ),
      child: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
        if (state is SignedInState) {
          return const NavigationGate();
        } else if (state is NeedsSigningInState) {
          return const ChooseLoginOrRegisterView();
        } else if (state is SigningInState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is LoginState) {
          return LoginRegisterView(
              key: const Key("LoginPage"),
              page: LoginRegisterPageType.login,
              user: state.user);
        } else if (state is PersonalInfoRegisterState) {
          return LoginRegisterView(
              key: const Key("RegisterFirstPage"),
              page: LoginRegisterPageType.registerPersonalInfo,
              user: state.user);
        } else if (state is RegisterState) {
          return LoginRegisterView(
              key: const Key("RegisterSecondPage"),
              page: LoginRegisterPageType.registerEmailAndPassword,
              user: state.user);
        }

        return const Center(
          child: Text("Wystąpił nieoczekiwany błąd. Spróbuj ponownie później"),
        );
      }),
    );
  }
}

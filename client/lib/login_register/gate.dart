import 'package:ccquarters/common/views/scrollable_view.dart';
import 'package:ccquarters/login_register/states.dart';
import 'package:ccquarters/login_register/views/choose.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/views/forgot_password.dart';
import 'package:ccquarters/login_register/views/login_register_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state is SignedInState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/home');
        });

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (state is NeedsSigningInState) {
        return const ChooseLoginOrRegisterView();
      } else if (state is LoadingState) {
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
      } else if (state is ForgotPasswordState) {
        return ScrollableView(
          view: ForgotPasswordPage(
            email: state.email,
            error: state.error,
          ),
        );
      } else if (state is ForgotPasswordSuccessState) {
        return const ForgotPasswordSuccessPage();
      }

      return const Center(
        child: Text("Wystąpił nieoczekiwany błąd. Spróbuj ponownie później"),
      );
    });
  }
}

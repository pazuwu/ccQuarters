import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/views/constrained_center_box.dart';
import 'package:ccquarters/common/views/loading_view.dart';
import 'package:ccquarters/login_register/states.dart';
import 'package:ccquarters/login_register/views/choose.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/login_register/views/forgot_password.dart';
import 'package:ccquarters/login_register/views/login_register_view.dart';
import 'package:ccquarters/login_register/views/user_not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/navigation/history_navigator.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key, this.child}) : super(key: key);

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      if (state is SignedInState) {
        if (child != null) {
          return child!;
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.go('/home');
        });
        return const LoadingView();
      } else if (state is NeedsSigningInState) {
        return const ChooseLoginOrRegisterView();
      } else if (state is LoadingState) {
        return const LoadingView();
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
        return ForgotPasswordPage(
          email: state.email,
          error: state.error,
        );
      } else if (state is ForgotPasswordSuccessState) {
        return const ForgotPasswordSuccessPage();
      } else if (state is UserNotFoundState) {
        return const UserNotFoundPage();
      } else if (state is ReEnterUserDataState) {
        return ReEnterUserDataPage(
          user: state.user,
          image: state.image,
          error: state.error,
        );
      } else if (state is ErrorState) {
        return ConstrainedCenterBox(
          child: ErrorMessage(
            state.message,
            actionButton: true,
            onAction: state is ErrorStateWhenGettingUser
                ? () => context.read<AuthCubit>().setUser()
                : () => context.read<AuthCubit>().updateUser(),
            actionButtonTitle: "Spróbuj ponownie",
          ),
        );
      }

      return const Center(
        child: Text("Wystąpił nieoczekiwany błąd. Spróbuj ponownie później"),
      );
    });
  }
}

import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ccquarters/navigation/history_navigator.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(largePaddingSize),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: MediaQuery.of(context).orientation == Orientation.portrait
              ? Padding(
                  padding: const EdgeInsets.all(largePaddingSize),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTitle(),
                      const SizedBox(height: 24),
                      _buildImage(context),
                      const SizedBox(height: 24),
                      _buildSignInButton(context),
                    ],
                  ),
                )
              : Center(
                  child: Row(
                    children: [
                      _buildImage(context),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          _buildTitle(),
                          const SizedBox(height: 24),
                          _buildSignInButton(context),
                        ],
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Text _buildTitle() {
    return const Text(
      'Wygląda na to, że nie\n jesteś zalogowany...',
      style: TextStyle(
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.center,
    );
  }

  Image _buildImage(BuildContext context) {
    return Image.asset(
      'assets/graphics/question.png',
      height: MediaQuery.of(context).size.height * 0.3,
    );
  }

  TextButton _buildSignInButton(BuildContext context) {
    return TextButton(
      child: Text(
        'Zaloguj się lub zarejestruj',
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Colors.blueGrey),
        textScaler: const TextScaler.linear(1.3),
      ),
      onPressed: () {
        context.read<AuthCubit>().signOut();
        context.go('/login');
      },
    );
  }
}

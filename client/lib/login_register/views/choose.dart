import 'dart:math';

import 'package:ccquarters/common/widgets/wide_text_button.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChooseLoginOrRegisterView extends StatelessWidget {
  const ChooseLoginOrRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: _buildSkipRegisterAndLoginBottomBar(context),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth:
                  MediaQuery.of(context).orientation == Orientation.landscape &&
                          MediaQuery.of(context).size.width > 700
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width),
          child: Padding(
            padding: const EdgeInsets.all(paddingSize),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildCompanyName(),
                FaIcon(
                  FontAwesomeIcons.house,
                  size: min(MediaQuery.of(context).size.width * 0.3, 200),
                  color: Theme.of(context).colorScheme.primary,
                ),
                _buildWelcome(context),
                _buildLoginOrRegisterButtons(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildSkipRegisterAndLoginBottomBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(paddingSize),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              context.read<AuthCubit>().skipRegisterAndLogin();
            },
            child: Text(
              "Przejdź dalej bez logowania",
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildCompanyName() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "CCQuarters",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Padding _buildWelcome(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 35, right: 35),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Cześć!",
            style: TextStyle(
              fontSize: 34,
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            "Najlepsze miejsce, aby znaleźć wymarzony dom lub mieszkanie",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Column _buildLoginOrRegisterButtons(BuildContext context) {
    return Column(
      children: [
        WideTextButton(
          onPressed: () {
            context.read<AuthCubit>().goToLoginPage();
          },
          text: "Zaloguj się",
        ),
        WideTextButton(
          onPressed: () {
            context.read<AuthCubit>().goToPersonalInfoRegisterPage();
          },
          text: "Zarejestruj się",
          isLightTheme: true,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.1,
        )
      ],
    );
  }
}

class ScrollableLoginView extends StatelessWidget {
  ScrollableLoginView({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return MediaQuery.of(context).size.height < 600
        ? Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 600,
                ),
                child: const ChooseLoginOrRegisterView(),
              ),
            ),
          )
        : const ChooseLoginOrRegisterView();
  }
}

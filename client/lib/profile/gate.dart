import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/profile/profile.dart';
import 'package:ccquarters/profile/sign_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key, this.user});

  final User? user;

  @override
  Widget build(BuildContext context) {
    return user != null
        ? BlocProvider(
            create: (_) => ProfilePageCubit(
              userService: context.read(),
              alertService: context.read(),
              houseService: context.read(),
            ),
            child: BlocBuilder<ProfilePageCubit, ProfilePageState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return const CircularProgressIndicator();
                } else if (state is DataState) {
                  return Profile(
                    user: user!,
                    myHouses: state.myHouses,
                    likedHouses: state.likedHouses,
                  );
                }

                return Container();
              },
            ),
          )
        : const SignInWidget();
  }
}

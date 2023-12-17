import 'package:ccquarters/common_widgets/error_message.dart';
import 'package:ccquarters/alerts/gate.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/profile/views/edit_profile.dart';
import 'package:ccquarters/profile/views/profile.dart';
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
              houseService: context.read(),
              userId: user!.id,
            ),
            child: BlocBuilder<ProfilePageCubit, ProfilePageState>(
              builder: (context, state) {
                if (state is ProfilePageInitialState) {
                  return Profile(
                    user: state.user,
                  );
                } else if (state is EditProfileState) {
                  return EditProfileView(
                    user: state.user,
                  );
                } else if (state is LoadingOrSendingDataState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ErrorState) {
                  return ErrorMessage(
                    state.message,
                    tip: state.tip,
                  );
                } else if (state is AlertsState) {
                  return const AlertsGate(
                  );
                } else if (state is AlertsState) {
                  return const AlertsGate(
                  );
                }

                return Container();
              },
            ),
          )
        : const SignInWidget();
  }
}

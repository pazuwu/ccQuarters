import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/alerts/gate.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/profile/views/edit_profile.dart';
import 'package:ccquarters/profile/views/profile.dart';
import 'package:ccquarters/login_register/sign_in_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key});

  @override
  Widget build(BuildContext context) {
    var user = context.read<AuthCubit>().user;
    return user != null
        ? BlocProvider(
            create: (_) => ProfilePageCubit(
              userService: context.read(),
              houseService: context.read(),
              userId: user.id,
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
                  return const AlertsGate();
                }

                return Container();
              },
            ),
          )
        : const SignInWidget();
  }
}

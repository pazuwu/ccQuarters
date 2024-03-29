import 'dart:typed_data';

import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/views/loading_view.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/model/users/user.dart';
import 'package:ccquarters/profile/cubit.dart';
import 'package:ccquarters/profile/states.dart';
import 'package:ccquarters/profile/views/edit_profile.dart';
import 'package:ccquarters/profile/views/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileGate extends StatelessWidget {
  const ProfileGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfilePageCubit(
        userService: context.read(),
        houseService: context.read(),
        userId: context.read<AuthCubit>().currentUserId,
      ),
      child: BlocBuilder<ProfilePageCubit, ProfilePageState>(
        builder: (context, state) {
          if (state is ProfilePageInitialState ||
              state is ErrorState ||
              state is LoadingDataState) {
            return _getWidgetWithGoBackToHome(state);
          } else {
            return BackButtonListener(
              onBackButtonPressed: () async {
                context.read<ProfilePageCubit>().goToProfilePage();
                return true;
              },
              child: _getWidgetWithGoBackToProfile(state),
            );
          }
        },
      ),
    );
  }

  Widget _getWidgetWithGoBackToHome(ProfilePageState state) {
    if (state is ProfilePageInitialState) {
      return Profile(
        user: state.user,
      );
    } else if (state is ErrorState) {
      return ErrorMessage(
        state.message,
        tip: state.tip,
      );
    } else {
      return const LoadingView();
    }
  }

  Widget _getWidgetWithGoBackToProfile(ProfilePageState state) {
    if (state is EditProfileState) {
      return EditProfileView(
        user: state.user,
        onSave: (BuildContext context, User user, Uint8List? image,
            bool deleteImage) {
          context.read<ProfilePageCubit>().updateUser(user, image, deleteImage);
        },
      );
    } else {
      return const LoadingView();
    }
  }
}

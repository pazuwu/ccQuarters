import 'dart:typed_data';

import 'package:ccquarters/common/messages/error_message.dart';
import 'package:ccquarters/common/messages/snack_messenger.dart';
import 'package:ccquarters/common/views/constrained_center_box.dart';
import 'package:ccquarters/login_register/cubit.dart';
import 'package:ccquarters/model/users/user.dart';
import 'package:ccquarters/profile/views/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserNotFoundPage extends StatelessWidget {
  const UserNotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedCenterBox(
      child: ErrorMessage(
        "Nie znaleziono użytkownika",
        tip: "Wygląda na to, że Twoje dane nie zostały\n"
            "poprawnie zapisane - uzupełnij je ponownie.\n"
            "Przepraszamy za niedogodności",
        actionButton: true,
        actionButtonTitle: "Przejdź do uzupełniania danych",
        onAction: () {
          context.read<AuthCubit>().goToReEnterUserDataPage();
        },
      ),
    );
  }
}

class ReEnterUserDataPage extends StatelessWidget {
  const ReEnterUserDataPage({
    super.key,
    required this.user,
    this.image,
    this.error,
  });

  final User user;
  final Uint8List? image;
  final String? error;

  @override
  Widget build(BuildContext context) {
    if (error != null) {
      SnackMessenger.showError(context, error!);
      context
          .read<AuthCubit>()
          .clearMessageForReEnterUserDataState(user, image);
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: EditProfileView(
        user: user,
        image: image,
        onSave: (BuildContext context, User user, Uint8List? image, _) {
          context.read<AuthCubit>().reEnterUserData(user, image);
        },
        reEnterUserData: true,
      ),
    );
  }
}

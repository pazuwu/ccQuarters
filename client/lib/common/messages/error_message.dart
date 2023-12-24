import 'package:ccquarters/common/messages/message.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ErrorMessage extends Message {
  const ErrorMessage(String errorMessage,
      {super.key, String? tip, super.closeButton})
      : super(
          title: errorMessage,
          subtitle: tip,
          icon: FontAwesomeIcons.triangleExclamation,
          padding: const EdgeInsets.all(8.0),
        );
}

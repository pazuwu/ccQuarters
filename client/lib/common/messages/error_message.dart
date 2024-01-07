import 'package:ccquarters/common/messages/message.dart';
import 'package:flutter/material.dart';

class ErrorMessage extends Message {
  ErrorMessage(
    String errorMessage, {
    super.key,
    String? tip,
    super.actionButton,
    super.actionButtonTitle,
    super.onAction,
  }) : super(
          title: errorMessage,
          subtitle: tip,
          imageWidget: Image.asset("assets/graphics/warning.png"),
          padding: const EdgeInsets.all(8.0),
        );
}

// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:ccquarters/house_details/views/contact_info.dart';
import 'package:ccquarters/house_details/views/contact_photo.dart';
import 'package:ccquarters/model/users/user.dart';
import 'package:flutter/material.dart';

class ButtonContactWidget extends StatelessWidget {
  const ButtonContactWidget({super.key, required this.user});

  final User user;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showModalBottomSheet(
        context: context,
        enableDrag: true,
        showDragHandle: true,
        builder: (BuildContext context) => Column(
          children: [
            ContactWidget(user: user),
            TextButton(
              child: const Text(
                "Zamknij",
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      child: const Text(
        "Skontaktuj się z wystawiającym!",
        textScaler: TextScaler.linear(1.3),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ContactWidget extends StatelessWidget {
  const ContactWidget({super.key, required this.user, this.additionalWidget});

  final User user;
  final Widget? additionalWidget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            const Text(
              "Skontaktuj się z wystawiającym ogłoszenie!",
              textScaler: TextScaler.linear(1.25),
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: _buildContactInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          width: double.infinity,
          height: 0,
        ),
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) => Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                ContactPhoto(
                  width: _getContactPhotoWidth(constraints),
                  photoUrl: user.photoUrl,
                ),
                ContactInfo(
                  width: _getContactInfoWidth(constraints),
                  user: user,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _getContactPhotoWidth(BoxConstraints constraints) {
    return max(constraints.maxWidth * 0.4, 180);
  }

  double _getContactInfoWidth(BoxConstraints constraints) {
    var prefereedSizeInRow = max(constraints.maxWidth * 0.6, 200.0);

    return prefereedSizeInRow + _getContactPhotoWidth(constraints) >
            constraints.maxWidth
        ? constraints.maxWidth
        : prefereedSizeInRow;
  }
}

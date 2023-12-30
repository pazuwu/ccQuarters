// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:ccquarters/common/images/image.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

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
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _getContactPhotoWidth(constraints),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(largePaddingSize),
                    child: user.photoUrl != null
                        ? ImageWidget(
                            imageUrl: user.photoUrl!,
                            shape: BoxShape.circle,
                          )
                        : Container(
                            decoration:
                                const BoxDecoration(shape: BoxShape.circle),
                            clipBehavior: Clip.antiAlias,
                            child: Image.asset("assets/graphics/avatar.png"),
                          ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: _getContactInfoWidth(constraints),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: largePaddingSize,
                      vertical: 32.0,
                    ),
                    child: Column(
                      children: [
                        _buildNameTable(context, user),
                        const SizedBox(height: 16),
                        _buildContactTable(context, user),
                      ],
                    ),
                  ),
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

  Widget _buildNameTable(BuildContext context, User user) {
    return Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(6),
        2: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        if ((user.name?.isNotEmpty ?? false) ||
            (user.surname?.isNotEmpty ?? false))
          _buildNameTableRow(
            context,
            Icons.person,
            "${user.name!} ${user.surname!}",
          ),
        if (user.company?.isNotEmpty ?? false)
          _buildNameTableRow(
            context,
            Icons.business,
            user.company!,
          ),
      ],
    );
  }

  Widget _buildContactTable(BuildContext context, User user) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(6),
        2: FlexColumnWidth(2),
      },
      children: [
        if (user.phoneNumber != null)
          _buildContactTableRow(context, user.phoneNumber!, Icons.phone,
              () => CallUtils.openDialer(user.phoneNumber!, context)),
        _buildContactTableRow(context, user.email, Icons.email,
            () => CallUtils.openDialerForEmail(user.email, context)),
      ],
    );
  }

  TableRow _buildNameTableRow(
      BuildContext context, IconData icon, String name) {
    return TableRow(
      children: [
        Icon(icon),
        Text(name),
        Container(),
      ],
    );
  }

  TableRow _buildContactTableRow(
    BuildContext context,
    String text,
    IconData icon,
    Function() onPressed,
  ) {
    return TableRow(
      children: [
        IconButton(
          onPressed: onPressed,
          icon: Icon(icon),
        ),
        Text(text),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () async => await Clipboard.setData(
            ClipboardData(text: text),
          ),
        ),
      ],
    );
  }
}

class CallUtils {
  CallUtils._();

  static Future<void> openDialer(
      String phoneNumber, BuildContext context) async {
    Uri callUrl = Uri(scheme: 'tel', path: phoneNumber);
    open(callUrl, context);
  }

  static Future<void> openDialerForEmail(
      String email, BuildContext context) async {
    Uri callUrl = Uri(scheme: 'mailto', path: email);
    open(callUrl, context);
  }

  static Future<void> open(Uri uri, BuildContext context) async {
    try {
      await launchUrl(uri);
    } catch (e) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Nie udała się próba połączenia z właścicielem'),
          content: const Text('Spróbuj ponownie później'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:ccquarters/common/consts.dart';
import 'package:ccquarters/model/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfo extends StatelessWidget {
  const ContactInfo({super.key, required this.width, required this.user});

  final double width;
  final User user;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: width,
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
    );
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

  TableRow _buildNameTableRow(
    BuildContext context,
    IconData icon,
    String name,
  ) {
    return TableRow(
      children: [
        Icon(icon),
        Text(name),
        Container(),
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

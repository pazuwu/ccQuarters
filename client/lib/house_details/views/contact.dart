// ignore_for_file: use_build_context_synchronously

import 'package:ccquarters/common_widgets/image.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/utils/consts.dart';
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
        "Skontaktuj się z wystawiającym",
        textScaler: TextScaler.linear(1.3),
      ),
    );
  }
}

class ContactWidget extends StatelessWidget {
  const ContactWidget({super.key, required this.user});

  final User user;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) => ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: constraints.maxWidth * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 16),
                  child: Text(
                    "Skontaktuj się z wystawiającym ogłoszenie!",
                    textScaler: TextScaler.linear(1.25),
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(largePaddingSize),
                            child: user.photoUrl != null
                                ? ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: constraints.maxHeight * 0.3,
                                    ),
                                    child: ImageWidget(
                                      imageUrl: user.photoUrl!,
                                      shape: BoxShape.circle,
                                    ),
                                  )
                                : const ClipOval(
                                    clipBehavior: Clip.antiAlias,
                                    child: Icon(Icons.person))),
                        _buildNameTable(context, user),
                      ],
                    ),
                  ],
                ),
                _buildContactTable(context, user),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildNameTable(BuildContext context, User user) {
  return Padding(
    padding: const EdgeInsets.all(largePaddingSize),
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(8),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        if (user.name != null && user.surname != null)
          _buildNameTableRow(
            context,
            Icons.person,
            "${user.name!} ${user.surname!}",
          ),
        if (user.company != null)
          _buildNameTableRow(
            context,
            Icons.business,
            user.company!,
          ),
      ],
    ),
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

TableRow _buildNameTableRow(BuildContext context, IconData icon, String name) {
  return TableRow(
    children: [
      Icon(icon),
      Text(name),
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

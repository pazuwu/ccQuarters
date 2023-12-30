import 'package:ccquarters/common/images/image.dart';
import 'package:ccquarters/model/user.dart';
import 'package:ccquarters/common/consts.dart';
import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key, required this.user});

  final User user;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: paddingSize),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                _buildPhoto(),
                _buildUserNameAndTimeSinceRegistration(context)
              ],
            ),
          ],
        ),
      ),
    );
  }

  LayoutBuilder _buildPhoto() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxWidth * 0.8,
          child: Padding(
            padding: const EdgeInsets.all(largePaddingSize),
            child: user.photoUrl != null && user.photoUrl!.isNotEmpty
                ? ImageWidget(
                    imageUrl: user.photoUrl!,
                    shape: BoxShape.circle,
                  )
                : Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      "assets/graphics/avatar.png",
                    ),
                  ),
          ),
        );
      },
    );
  }

  Column _buildUserNameAndTimeSinceRegistration(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (user.name != null && user.surname != null)
          Text(
            "${user.name!} ${user.surname!}",
            style: Theme.of(context).textTheme.headlineSmall,
            textScaler: const TextScaler.linear(0.8),
          ),
        if (user.company != null)
          Text(
            user.company!,
            style: user.name != null && user.surname != null
                ? TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                    fontWeight: FontWeight.w600)
                : Theme.of(context).textTheme.headlineSmall,
          ),
        Text(
          "Jesteś z nami od ${_getTimeSinceRegistration(user)}!",
          textScaler: const TextScaler.linear(1.2),
        ),
      ],
    );
  }

  String _getTimeSinceRegistration(User user) {
    var daysSinceRegistration =
        DateTime.now().difference(user.registerTime).inDays;

    if (daysSinceRegistration == 0) {
      return "dzisiaj";
    } else if (daysSinceRegistration == 1) {
      return "wczoraj";
    } else if (daysSinceRegistration < 30) {
      return "$daysSinceRegistration dni";
    } else if (daysSinceRegistration < 60) {
      return "miesiąca";
    } else if (daysSinceRegistration < 365) {
      return "${(daysSinceRegistration / 30).floor()} miesięcy";
    } else {
      return "${(daysSinceRegistration / 365).floor()} lat";
    }
  }
}

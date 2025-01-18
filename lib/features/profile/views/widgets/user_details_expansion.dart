import 'package:animate_do/animate_do.dart' as animate;
import 'package:flutter/material.dart';
import 'package:navy/utils/gaps.dart';

import '../../../authentication/model/user_response.dart';

class UserDetailsExpansion extends StatelessWidget {
  const UserDetailsExpansion({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    const textColor = Colors.white;
    const backgroundColor = Colors.black26;

    return animate.SlideInRight(
      child: Column(
        children: [
          if (user.email.isNotEmpty)
            _buildExpansionTile(
              context: context,
              icon: Icons.email_outlined,
              title: 'Email',
              content: user.email,
              textColor: textColor,
              backgroundColor: backgroundColor,
            ),
          if (user.phone?.isNotEmpty ?? false)
            _buildExpansionTile(
              context: context,
              icon: Icons.phone_outlined,
              title: 'Phone',
              content: user.phone!,
              textColor: textColor,
              backgroundColor: backgroundColor,
            ),
          if (user.location?.isNotEmpty ?? false)
            _buildExpansionTile(
              context: context,
              icon: Icons.location_on_outlined,
              title: 'Location',
              content: user.location!,
              textColor: textColor,
              backgroundColor: backgroundColor,
            ),
          if (user.website?.isNotEmpty ?? false)
            _buildExpansionTile(
              context: context,
              icon: Icons.language_outlined,
              title: 'Website',
              content: user.website!,
              textColor: textColor,
              backgroundColor: backgroundColor,
            ),
        ],
      ),
    );
  }

  Widget _buildExpansionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required Color textColor,
    required Color backgroundColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          expandedAlignment: Alignment.bottomCenter,
          leading: Icon(icon, color: textColor),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0)),
          ),
          title: Text(
            title,
            style: TextStyle(color: textColor),
          ),
          backgroundColor: backgroundColor,
          collapsedBackgroundColor: backgroundColor,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  gapW16,
                  Expanded(
                    child: Text(
                      content,
                      style: TextStyle(color: textColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

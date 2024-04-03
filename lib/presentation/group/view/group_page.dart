import 'package:flutter/material.dart';

import '../../../core/resources/style.dart';
import '../../widgets/appBar.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<StatefulWidget> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  Widget _friendBtn(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(context, MaterialPageRoute(
        // builder: (context) => const FriendsActivity(),
        builder: (context) => Container(),
      )), 
      icon: const Icon(Icons.people_alt_outlined,
        size: 28.0,
        color: AppStyle.primaryColor,
      ),
    );
  }

  Widget _challengeType() {
    return Column(
      children: [
        Text("Let's get started. Select your challenge type",
          style: AppStyle.heading1(),
        ),
        const SizedBox(height: 20.0),
        _challengeTypeItem(
          onTap: () async {
            Navigator.pop<void>(context);
          },
          title: "Group Goal",
          subtitle: "Chase a goal as a group. All activities will count towards a single goal.",
          iconData: Icons.photo_outlined,
        ),
        _challengeTypeItem(
          onTap: () {

          },
          title: "Fastest Effort",
          subtitle: "Log the most distance in one activity.",
          iconData: Icons.camera_alt_outlined,
        ),
      ],
    );
  }

  Widget _challengeTypeItem({
    required String title,
    required String subtitle,
    required IconData iconData,
    Color? iconColor,
    required void Function() onTap,
  }) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: AppStyle.horizontalPadding,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppStyle.horizontalPadding,
      ),
      iconColor: iconColor ?? Colors.grey.shade500,
      leading: Icon(
        iconData,
        size: 28.0,
      ),
      title: Text(
        title,
        style: AppStyle.heading2(),
      ),
      subtitle: Text(
        subtitle,
        style: AppStyle.bodyText(),
      ),
    );
  }

  Future<void> _showChallengeCreationForm(BuildContext context) {
    return showModalBottomSheet<void>(
      constraints: const BoxConstraints(
        minHeight: 200.0,
      ),
      backgroundColor: AppStyle.surfaceColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppStyle.borderRadius),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppStyle.horizontalPadding,
            vertical: 4.0,
          ),
          child: _challengeType()
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.get(
        title: "Groups",
        leading: _friendBtn(context),
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppStyle.neutralColor400),
          ),
        ),
        child: Column(
          children: [
            TextButton(
              onPressed: () => _showChallengeCreationForm(context),
              style: TextButton.styleFrom(
                backgroundColor: AppStyle.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppStyle.borderRadius),
                ),
                minimumSize: const Size.fromHeight(40.0)
              ),
              child: Text(
                "Create Challenge",
                style: AppStyle.heading2(
                    color: AppStyle.surfaceColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

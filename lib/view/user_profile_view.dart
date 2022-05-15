import 'package:app/util/chat/chat_data.dart';
import 'package:app/widget/user_informations.dart';
import 'package:flutter/material.dart';

import '../widget/app_bar.dart';

class UserProfileView extends StatefulWidget {
  final String backLabel;
  final int toId;
  final ChatFrom? chatFrom;
  const UserProfileView({
    Key? key,
    required this.backLabel,
    required this.toId,
    this.chatFrom,
  }) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: DDAppBar(
          context,
          title: widget.backLabel,
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: UserInformations(
            toId: widget.toId,
            chatFrom: widget.chatFrom,
          ),
        ),
      );
}

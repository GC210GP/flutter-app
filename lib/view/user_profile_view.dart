import 'package:app/util/chat/chat_data.dart';
import 'package:app/widget/user_informations.dart';
import 'package:flutter/material.dart';

import '../widget/app_bar.dart';

class UserProfileView extends StatelessWidget {
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
  Widget build(BuildContext context) => Scaffold(
        appBar: DDAppBar(
          context,
          title: backLabel,
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: UserInformations(
            toId: toId,
            chatFrom: chatFrom,
          ),
        ),
      );
}

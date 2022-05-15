import 'package:app/model/like.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/widget/user_informations.dart';
import 'package:flutter/material.dart';

import '../widget/app_bar.dart';

class UserProfileView extends StatefulWidget {
  final String title;
  final int toId;
  const UserProfileView({Key? key, required this.title, required this.toId})
      : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: DDAppBar(
          context,
          title: widget.title,
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: UserInformations(toId: widget.toId),
        ),
      );
}

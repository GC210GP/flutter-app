import 'dart:io';

import 'package:app/util/theme/colors.dart';
import 'package:app/view/home/community_page.dart';
import 'package:app/view/home/message_page.dart';
import 'package:app/view/home/setting_page.dart';
import 'package:app/view/home/suggest_page.dart';
import 'package:app/widget/bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int pageIdx = 1;

  CustomButtomNavigationController controller =
      CustomButtomNavigationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DDColor.background,
      appBar: AppBar(
        toolbarHeight: 0,
        shadowColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ///
              /// PageView

              if (pageIdx == 1)
                const Expanded(child: SuggestionPageView())
              else if (pageIdx == 2)
                const Expanded(child: MessagePageView())
              else if (pageIdx == 3)
                const Expanded(child: CommunityPageView())
              else if (pageIdx == 4)
                const Expanded(child: SettingPageView()),

              ///
              /// Safe area for BottomNavigation
              if (MediaQuery.of(context).viewInsets.bottom <= 0.0)
                SizedBox(height: Platform.isIOS ? 115 - 7 : 95 - 7),
            ],
          ),

          ///
          /// BottomNavigation
          Positioned.fill(
            top: MediaQuery.of(context).size.height -
                (Platform.isIOS ? 115 + 45 : 95 + 45),
            child: CustomBottomNavigation(
              index: pageIdx,
              controller: controller,
              onPressed: () {
                pageIdx = controller.currentIdx;
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }
}

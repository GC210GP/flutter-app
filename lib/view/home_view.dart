import 'package:blood_donation/util/colors.dart';
import 'package:blood_donation/view/subpage/community_page.dart';
import 'package:blood_donation/view/subpage/message_page.dart';
import 'package:blood_donation/view/subpage/setting_page.dart';
import 'package:blood_donation/view/subpage/suggest_page.dart';
import 'package:blood_donation/widget/bottom_navigation.dart';
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
      body: Column(
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
          /// BottomNavigation

          CustomBottomNavigation(
            index: pageIdx,
            controller: controller,
            onPressed: () {
              pageIdx = controller.currentIdx;
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

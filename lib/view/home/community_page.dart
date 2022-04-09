import 'package:app/model/association.dto.dart';
import 'package:app/model/person.dto.dart';
import 'package:app/model/post.dto.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/http_conn.dart';
import 'package:app/util/theme/colors.dart';
import 'package:app/util/theme/font.dart';
import 'package:app/view/community/community_board_view.dart';
import 'package:app/view/community/community_view.dart';
import 'package:app/widget/community_item.dart';
import 'package:app/widget/input_box.dart';
import 'package:app/widget/page_title_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum Status {
  searching,
  starred,
  searchResult,
  unauthorized,
}

class CommunityPageView extends StatefulWidget {
  const CommunityPageView({Key? key}) : super(key: key);

  @override
  _CommunityPageViewState createState() => _CommunityPageViewState();
}

class _CommunityPageViewState extends State<CommunityPageView> {
  ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  TextEditingController textController = TextEditingController();

  Status status = Status.unauthorized;

  double pageOpacity = 0;
  bool isLoading = true;

  List<AssociationDto> starredCommunity = [];
  List<AssociationDto> searchedCommunity = [];
  List<List<PostDto>> starredCommunityPosts = [];

  @override
  void initState() {
    super.initState();

    scrollController.addListener(() {
      setState(() {});
    });
    textController.addListener(() {
      setState(() {});
    });
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        status = Status.searching;
      } else if (textController.text.isEmpty) {
        status = Status.starred;
      } else {
        status = Status.searchResult;
      }
    });
    pageOpacity = 0;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      getStarredCommunity().then((value) {});
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: pageOpacity,
      duration: const Duration(milliseconds: 100),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLoading)
              Center(
                child: Container(
                  width: 50,
                  height: 100,
                  padding: const EdgeInsets.only(bottom: 50.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 7.5,
                    color: DDColor.primary.shade600,
                    backgroundColor: DDColor.disabled,
                  ),
                ),
              )
            else if (status != Status.unauthorized)
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.only(
                      top: 50.0,
                      bottom: starredCommunity != null
                          ? (3 - starredCommunity.length) * 150 + 20.0
                          : 20.0),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    // 검색

                    Container(
                      height: 50.0,
                      margin: const EdgeInsets.only(bottom: 60),
                      child: Stack(
                        children: [
                          DDTextField(
                            padding: EdgeInsets.fromLTRB(45, 21, 15, 0),
                            hintText: "커뮤니티 검색...",
                            focusNode: focusNode,
                            controller: textController,
                            onChanged: (value) => searchCommunity(value),
                          ),
                          Positioned(
                            top: 0,
                            bottom: 3,
                            left: 15.0,
                            child: Icon(
                              CupertinoIcons.search,
                              color: DDColor.disabled,
                              size: 25.0,
                            ),
                          ),
                          if (textController.text.isNotEmpty)
                            Positioned(
                              top: 0,
                              bottom: 0,
                              right: 15.0,
                              child: CupertinoButton(
                                padding: const EdgeInsets.all(0.0),
                                child: Icon(
                                  CupertinoIcons.xmark_circle_fill,
                                  color: DDColor.disabled,
                                  size: 25.0,
                                ),
                                onPressed: () {
                                  textController.text = "";
                                  focusNode.unfocus();
                                  status = Status.starred;
                                  scrollController.jumpTo(110.0);
                                  setState(() {});
                                },
                              ),
                            )
                        ],
                      ),
                    ),

                    if (status == Status.starred)
                      StarredItems(
                        communityList: starredCommunity,
                        postsList: starredCommunityPosts,
                        onMorePressed: (associationDto) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommunityView(
                              associationDto: associationDto,
                              isStarred: true,
                            ),
                          ),
                        ).then(
                          (value) => getStarredCommunity(),
                        ),
                        onStarPressed: (uaid) => removeCommunityStar(uaid),
                      ),
                    if (status == Status.searchResult ||
                        status == Status.searching)
                      SearchedItem(
                        searchQuery: textController.text,
                        searchResult: searchedCommunity,
                        onCreatePressed: createCommunity,
                        onItemPressed: (associationDto) => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommunityView(
                              associationDto: associationDto,
                            ),
                          ),
                        ),
                      ),

                    ///
                    ///
                    ///
                  ],
                ),
              )
            else
              const Expanded(child: UnauthorizedPage()),
          ],
        ),
      ),
    );
  }

  Future<List<PostDto>> getCommunityBoards(int aid) async {
    Map<String, dynamic> result = await GlobalVariables.httpConn.get(
      apiUrl: "/posts?associationId=$aid&page=1&size=5&sort=id,desc",
    );

    List<PostDto> posts = [];

    if (result['httpConnStatus'] == httpConnStatus.success) {
      for (var i in result['data']['content']) {
        posts.add(
          PostDto(
              pid: i["id"],
              title: i["title"] ?? "",
              content: i["content"] ?? "",
              isActiveGiver: i["isActiveGiver"] ?? false,
              isActiveReceiver: i["isActiveReceiver"] ?? false,
              cratedDate:
                  DateTime.parse(i["createdDate"] ?? DateTime(1).toString()),
              modifiedDate:
                  DateTime.parse(i["modifiedDate"] ?? DateTime(1).toString()),
              userId: i['userId'],
              userNickname: i['userNickname']),
        );
      }
    }

    return posts;
  }

  removeCommunityStar(int uaid) async {
    Map<String, dynamic> resultAssociation = await GlobalVariables.httpConn
        .delete(apiUrl: "/user-associations/$uaid");

    if (resultAssociation['httpConnStatus'] == httpConnStatus.success) {
      await getStarredCommunity();
      setState(() {});
    }
  }

  Future<void> getStarredCommunity() async {
    pageOpacity = 0.0;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 200));

    isLoading = true;
    starredCommunity.clear();
    pageOpacity = 1.0;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 200));

    Map<String, dynamic> result =
        await GlobalVariables.httpConn.get(apiUrl: "/user-associations");

    switch (result['httpConnStatus']) {
      case httpConnStatus.success:
        status = Status.starred;
        break;
      default:
        status = Status.unauthorized;
        break;
    }

    for (Map<String, dynamic> i in result["data"]) {
      Map<String, dynamic> resultAssociation = await GlobalVariables.httpConn
          .get(apiUrl: "/associations?associationId=${i['associationId']}");
      if (resultAssociation['httpConnStatus'] == httpConnStatus.success) {
        starredCommunity.add(
          AssociationDto(
            aid: i['associationId'],
            uaid: i['userAssociationId'],
            associationName: i['associationName'],
            cratedDate:
                DateTime.parse(resultAssociation['data']['createdDate']),
            modifiedDate:
                DateTime.parse(resultAssociation['data']['modifiedDate']),
          ),
        );

        // 포스트 가져옴
        for (AssociationDto i in starredCommunity) {
          starredCommunityPosts.add(await getCommunityBoards(i.aid));
        }
      }
    }

    pageOpacity = 0.0;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 200));

    isLoading = false;
    pageOpacity = 1.0;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 50));
    scrollController.jumpTo(110.0);
    await Future.delayed(const Duration(milliseconds: 200));
  }

  bool isSearching = false;

  Future<void> searchCommunity(String query) async {
    if (!isSearching && query.isNotEmpty) {
      isSearching = true;

      searchedCommunity.clear();

      Map<String, dynamic> result = await GlobalVariables.httpConn.get(
          apiUrl: "/associations/search-name", queryString: {"query": query});

      if (result['httpConnStatus'] == httpConnStatus.success) {
        for (Map<String, dynamic> i in result['data']) {
          searchedCommunity.add(
            AssociationDto(
              aid: i['id'],
              uaid: -1,
              associationName: i['associationName'],
              cratedDate: DateTime.parse(i['createdDate']),
              modifiedDate: DateTime.parse(i['modifiedDate']),
            ),
          );
        }
      }
      setState(() {});

      isSearching = false;
    }
  }

  Future<void> createCommunity(String name) async {
    Map<String, dynamic> result = await GlobalVariables.httpConn
        .post(apiUrl: "/associations", body: {"associationName": name});

    if (result['httpConnStatus'] == httpConnStatus.success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommunityView(
            associationDto: AssociationDto(
              aid: result['id'],
              uaid: -1,
              associationName: result['associationName'],
              cratedDate: DateTime.parse(result['createdDate']),
              modifiedDate: DateTime.parse(result['modifiedDate']),
            ),
          ),
        ),
      );
    }
  }
  // 뷰 재활용하거나 모달 활용해야 함
}

///
///
///
///
///
///
///
class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageTitleWidget(
          title: "커뮤니티",
          margin: EdgeInsets.fromLTRB(0, 50.0, 0, 20.0),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "📝",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DDFontFamily.nanumSR,
                    fontWeight: DDFontWeight.extraBold,
                    fontSize: DDFontSize.h1,
                    color: DDColor.grey,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  "커뮤니티 활동을 하려면 로그인이 필요해요!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DDFontFamily.nanumSR,
                    fontWeight: DDFontWeight.extraBold,
                    fontSize: DDFontSize.h4,
                    color: DDColor.grey,
                  ),
                ),
              ),
              const SizedBox(height: 80.0),
            ],
          ),
        ),
      ],
    );
  }
}

class CommunityItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onStarPressed;
  final String title;
  final bool? isStarred;
  final Color? hashtagColor;

  const CommunityItem({
    Key? key,
    required this.title,
    this.isStarred,
    this.onPressed,
    this.onStarPressed,
    this.hashtagColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: DDColor.widgetBackgroud,
        border: Border(
          bottom: BorderSide(
            color: DDColor.background,
          ),
        ),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.all(.0),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "#",
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.extraBold,
                  fontSize: DDFontSize.h3,
                  color: hashtagColor ?? DDColor.grey,
                ),
              ),
              const SizedBox(width: 3.0),
              Text(
                title,
                style: TextStyle(
                  fontFamily: DDFontFamily.nanumSR,
                  fontWeight: DDFontWeight.bold,
                  fontSize: DDFontSize.h3,
                  color: DDColor.fontColor,
                ),
              ),
              if (isStarred != null)
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(0.0),
                      child: Icon(
                        CupertinoIcons.star_fill,
                        color: isStarred!
                            ? Colors.yellowAccent.shade700
                            : DDColor.disabled,
                      ),
                      onPressed: onStarPressed,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchedItem extends StatelessWidget {
  final String searchQuery;
  final List<AssociationDto> searchResult;
  final Function(String name)? onCreatePressed;
  final Function(AssociationDto associationDto)? onItemPressed;
  const SearchedItem({
    Key? key,
    required this.searchQuery,
    required this.searchResult,
    this.onCreatePressed,
    this.onItemPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(GlobalVariables.radius),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (AssociationDto i in searchResult)
            CommunityItem(
                title: "${i.associationName}",
                // isStarred: true,
                onPressed: () =>
                    {if (onItemPressed != null) onItemPressed!(i)}),
          if (searchQuery.isNotEmpty)
            CommunityItem(
              title: '"${searchQuery}" 추가하기',
              hashtagColor: DDColor.primary,
              onPressed: () =>
                  {if (onCreatePressed != null) onCreatePressed!(searchQuery)},
            )
        ],
      ),
    );
  }
}

class StarredItems extends StatelessWidget {
  final List<AssociationDto> communityList;
  final List<List<PostDto>> postsList;
  final Function(AssociationDto associationDto)? onMorePressed;
  final Function(int uaid)? onStarPressed;

  const StarredItems({
    Key? key,
    required this.communityList,
    required this.postsList,
    this.onMorePressed,
    this.onStarPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < communityList.length; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  PageTitleWidget(
                    title: communityList[i].associationName,
                    margin: const EdgeInsets.only(bottom: 10.0),
                  ),
                  Positioned(
                    right: 0,
                    height: 30.0,
                    width: 30.0,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10.0, bottom: 5.0),
                      child: CupertinoButton(
                        padding: const EdgeInsets.all(0.0),
                        child: Icon(
                          CupertinoIcons.star_fill,
                          color: Colors.yellowAccent.shade700,
                          size: 20.0,
                        ),
                        onPressed: () {
                          if (onStarPressed != null)
                            onStarPressed!(communityList[i].uaid);
                        },
                      ),
                    ),
                  )
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(GlobalVariables.radius),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int n = 0; n < postsList[i].length; n++)
                      CommunityBoardItem(
                        author: postsList[i][n].userNickname,
                        title: postsList[i][n].title.length >= 20
                            ? postsList[i][n].title.substring(0, 20)
                            : postsList[i][n].title,
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CommunityBoardView(
                              postDto: postsList[i][n],
                            ),
                          ),
                        ),
                      ),
                    CommunityBoardItem(
                      author: "",
                      title: "더보기...\n",
                      fontColor: DDColor.grey,
                      onPressed: () {
                        if (onMorePressed != null) {
                          onMorePressed!(communityList[i]);
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          )
      ],
    );
  }
}

// post

class PostDto {
  int pid;
  String title;
  String content;
  bool isActiveGiver;
  bool isActiveReceiver;
  DateTime cratedDate;
  DateTime modifiedDate;
  int userId;
  String userNickname;

  PostDto({
    required this.pid,
    required this.title,
    required this.content,
    required this.isActiveGiver,
    required this.isActiveReceiver,
    required this.cratedDate,
    required this.modifiedDate,
    required this.userId,
    required this.userNickname,
  });
}

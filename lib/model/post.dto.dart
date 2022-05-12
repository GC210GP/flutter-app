// post

class PostDto {
  int pid;
  String title;
  String content;
  bool isActiveGiver;
  bool isActiveReceiver;
  DateTime createdDate;
  DateTime modifiedDate;
  int userId;
  String userNickname;
  int associationId;

  PostDto({
    required this.pid,
    required this.title,
    required this.content,
    required this.associationId,
    required this.isActiveGiver,
    required this.isActiveReceiver,
    required this.createdDate,
    required this.modifiedDate,
    required this.userId,
    required this.userNickname,
  });

  @override
  String toString() {
    return "{pid: $pid, title: $title, content: $content, associationId: $associationId, isActiveGiver: $isActiveGiver, isActiveReceiver: $isActiveReceiver, createdDate: $createdDate, modifiedDate: $modifiedDate, userId: $userId,userNickname: $userNickname}";
  }
}

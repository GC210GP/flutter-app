// post

class PostDto {
  int pid;
  String title;
  String content;
  bool isActive;
  DateTime cratedDate;
  DateTime updatedDate;

  PostDto({
    required this.pid,
    required this.title,
    required this.content,
    required this.isActive,
    required this.cratedDate,
    required this.updatedDate,
  });
}

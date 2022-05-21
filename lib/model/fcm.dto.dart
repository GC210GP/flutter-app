class FcmDto {
  Map<String, dynamic>? data;
  String token;
  String title;
  String body;
  String? image;

  FcmDto({
    this.data = const {},
    required this.token,
    required this.title,
    required this.body,
    this.image,
  });
}

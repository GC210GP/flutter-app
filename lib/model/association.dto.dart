// association

class AssociationDto {
  int aid;
  int uaid;
  String associationName;
  DateTime createdDate;
  DateTime modifiedDate;

  AssociationDto({
    required this.aid,
    required this.uaid,
    required this.associationName,
    required this.createdDate,
    required this.modifiedDate,
  });

  @override
  String toString() {
    return "{aid: $aid, uaid: $uaid, associationName: $associationName, createdDate: $createdDate, modifiedDate: $modifiedDate}";
  }
}

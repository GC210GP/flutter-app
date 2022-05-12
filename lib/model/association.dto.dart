// association

class AssociationDto {
  int aid;
  int uaid;
  String associationName;
  DateTime cratedDate;
  DateTime modifiedDate;

  AssociationDto({
    required this.aid,
    required this.uaid,
    required this.associationName,
    required this.cratedDate,
    required this.modifiedDate,
  });

  @override
  String toString() {
    return "{aid: $aid, uaid: $uaid, associationName: $associationName, cratedDate: $cratedDate, modifiedDate: $modifiedDate}";
  }
}

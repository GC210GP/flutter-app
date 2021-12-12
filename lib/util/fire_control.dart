import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' as fs;
// import 'package:firebase_storage/firebase_storage.dart' as fbs;
// import 'package:firebase_auth/firebase_auth.dart' as fa;

class FireControl {
  // Make singleton instance
  // FireControl._();
  // static final FireControl _instance = FireControl._();
  // static FireControl get instance => _instance;

  bool isInit = false;
  final String collectionName;
  String? docName;

  FireControl({
    required this.collectionName,
    this.docName,
  });

  late fs.DocumentReference _doc;
  late fs.CollectionReference _collection;
  // late fbs.FirebaseStorage _storage;

  fs.CollectionReference get collection => _collection;

  ///
  /// ### 초기화
  Future<bool> init() async {
    try {
      _collection = fs.FirebaseFirestore.instance.collection(collectionName);
    } catch (e) {
      print("Error to init. $e");
      isInit = false;
      return false;
    }

    // bool result = await _signIn(
    //   id: Secret.firebaseAuthEmail,
    //   pw: Secret.firebaseAuthPassword,
    // );

    isInit = true;
    return true;
  }

  ///
  /// ### Row 추가/수정
  Future<bool> insertUpdate({
    required String docName,
    required Object data,
    required int idx,
  }) async {
    try {
      _doc =
          fs.FirebaseFirestore.instance.collection(collectionName).doc(docName);

      // if (data is User) {
      //   await _doc.set(
      //     {
      //       '"$idx"': {
      //         '"name"': '"${data.name}"',
      //         '"age"': data.age,
      //         '"job"': '"${data.job}"',
      //         '"gender"': data.gender == Gender.male ? '"M"' : '"F"',
      //         '"insurance"': data.insurance,
      //         '"cancer"': data.cancer,
      //         '"brain"': data.brain,
      //         '"heart"': data.heart,
      //         '"bankDeposit"': data.bankDeposit,
      //         '"bankSaving"': data.bankSaving,
      //         '"parkingAccount"': data.parkingAccount,
      //         '"lifeAccount"': data.lifeAccount,
      //         '"admission"': data.admission,
      //         '"surgery"': data.surgery,
      //         '"indemnity"': data.indemnity,
      //       }
      //     },
      //     fs.SetOptions(merge: true),
      //   );
      // } else {
      //   await _doc.set(
      //     data,
      //     fs.SetOptions(merge: true),
      //   );
      // }

      return true;
    } catch (e) {
      print("Failed to add: $e");
      return false;
    }
  }

  ///
  /// ### Row 삭제
  Future<bool> delete({
    required String docName,
    required String targetKey,
  }) async {
    try {
      _doc =
          fs.FirebaseFirestore.instance.collection(collectionName).doc(docName);
      await _doc.update({
        '"$targetKey"': fs.FieldValue.delete(),
      });
      return true;
    } catch (e) {
      print("Failed to delete: $e");
      return false;
    }
  }

  Future<List<String>> getDocList() async {
    List<String> result = [];
    var docResult = await _collection.get();
    for (fs.QueryDocumentSnapshot i in docResult.docs) {
      result.add(i.id);
    }
    return result;
  }

  ///
  /// ### doc 읽어오기 (DTO 써야 할 듯), (쿼리추가필요)
  Future<dynamic> getAll({
    required String docName,
  }) async {
    try {
      _doc =
          fs.FirebaseFirestore.instance.collection(collectionName).doc(docName);
      fs.DocumentSnapshot result = await _doc.get();
      // print(result.data());
      dynamic resultJson = jsonDecode(result.data().toString());

      return Future.value(resultJson);
    } catch (e) {
      print("Failed to get doc: $e");
      return null;
    }

    // result.data["dddd"]

    // print(snapshot.docs.length);

    // for (var i in snapshot.docs) {
    //   print(i.data());
    // }
    // return snapshot.toString();
  }

  ///
  /// ### doc 지우기
  Future<bool> deleteDoc({
    required String docName,
  }) async {
    _doc =
        fs.FirebaseFirestore.instance.collection(collectionName).doc(docName);
    try {
      await _doc.delete();
      return true;
    } catch (e) {
      print("Failed to delete doc: $e");
      return false;
    }
  }
}

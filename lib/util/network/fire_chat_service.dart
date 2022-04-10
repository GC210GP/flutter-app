import 'dart:async';

import 'package:app/util/chat/chat_data.dart';
import 'package:app/util/global_variables.dart';
import 'package:app/util/network/fire_control.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireChatService {
  late ChatData _chatdata;
  late DocumentReference<Object?> _document;

  late final FireControl _fireControl;

  final void Function(List<ChatMessage>)? onChanged;
  StreamSubscription<DocumentSnapshot<Object?>>? listener;

  FireChatService({
    this.onChanged,
  }) {
    assert(FireControl.instance != null, "FireControl was not initialized!");
    if (FireControl.instance != null) {
      _fireControl = FireControl.instance!;
    }
  }

  void streamListener(DocumentSnapshot<Object?> event) {
    _chatdata = ChatData(event.data().toString());
    if (onChanged != null) onChanged!(_chatdata.content);
  }

  ///
  ///
  ///

  Future<Stream<DocumentSnapshot<Object?>>> initChatroom({
    String? chatroomId,
    required int fromId,
    required int toId,
    bool isListen = true,
  }) async {
    CollectionReference<Object?> collection = _fireControl.collection;
    String? targetChatroomId;

    List<String> docList = await _fireControl.getDocList();

    // 처음 채팅방 생성하는 경우
    if (chatroomId == null) {
      String str1 = fromId.toString() + "=" + toId.toString();
      String str2 = toId.toString() + "=" + fromId.toString();
      bool isChatroomCreated = false;
      targetChatroomId = str1;

      if (docList.contains(str1)) {
        isChatroomCreated = true;
      } else if (docList.contains(str2)) {
        isChatroomCreated = true;
        targetChatroomId = str2;
      }

      if (!isChatroomCreated) {
        collection.doc(targetChatroomId).set(
          {
            '"metadata"': {
              '"chatFrom"': '"${ChatFrom.community}"',
              '"member"': [fromId, toId],
              '"isDone"': false,
              '"suggestionIdx"': 0,
            },
            '"content"': [],
          },
        );
      }
    }
    // 기존 채팅방 있는 경우
    else {
      targetChatroomId = chatroomId;
    }

    _document = collection.doc(targetChatroomId);
    if (isListen) listener = _document.snapshots().listen(streamListener);

    return _document.snapshots();
  }

  ///
  ///
  ///

  Future<void> terminateListener() async {
    if (listener != null) await listener!.cancel();
  }

  ///
  ///
  ///

  sendMessage({required String message}) {
    _chatdata.content.add(
      ChatMessage(
        senderId: GlobalVariables.userDto!.uid,
        timestamp: DateTime.now(),
        msg: message,
      ),
    );
    _document.update(_chatdata.toFireStore());
  }
}

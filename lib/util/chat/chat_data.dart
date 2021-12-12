import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatData {
  late ChatMetadata metadata;
  late List<ChatMessage> content;

  ChatData(String rawStr) {
    dynamic result = jsonDecode(rawStr);

    dynamic rawMetadata = result['metadata'];
    dynamic rawContent = result['content'];

    List<int> memberList = [];
    for (var i in rawMetadata['member']) {
      memberList.add(i);
    }

    metadata = ChatMetadata(
      isDone: rawMetadata['isDone'],
      member: memberList,
    );

    List<dynamic> rawContents = rawContent;
    List<ChatMessage> contents = [];

    for (Map<String, dynamic> i in rawContents) {
      contents.add(
        ChatMessage(
          senderId: i['senderId'],
          timestamp: DateTime.parse(i['timestamp']),
          msg: i['msg'],
        ),
      );
    }

    content = contents;
  }

  Map<String, Object> toFireStore() {
    List<Object> contentList = [];

    for (ChatMessage i in content) {
      contentList.add({
        '"senderId"': i.senderId,
        '"timestamp"': '"${i.timestamp.toString()}"',
        '"msg"': '"${i.msg}"',
      });
    }

    return {
      '"metadata"': {
        '"member"': metadata.member,
        '"isDone"': metadata.isDone,
      },
      '"content"': contentList,
    };
  }
}

class ChatMetadata {
  ChatMetadata({
    required this.member,
    required this.isDone,
  });

  final List<int> member;
  final bool isDone;

  @override
  String toString() {
    print("""
    {
      member: $member,
      isDone: $isDone,
    }
    """);
    return super.toString();
  }
}

class ChatMessage {
  ChatMessage({
    required this.senderId,
    required this.timestamp,
    required this.msg,
  });

  final int senderId;
  final DateTime timestamp;
  final String msg;

  @override
  String toString() {
    print("""
    {
      senderId: $senderId,
      timestamp: $timestamp,
      msg: $msg,
    }
    """);
    return super.toString();
  }
}

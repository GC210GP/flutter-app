import 'dart:convert';

import 'package:flutter/material.dart';

class ChatData {
  late ChatMetadata metadata;
  late List<ChatMessage> content;

  ChatData(String rawStr) {
    dynamic result = jsonDecode(rawStr);

    dynamic rawMetadata = result['metadata'];
    dynamic rawContent = result['content'];
    dynamic rawChatFrom = result['chatFrom'];

    List<int> memberList = [];
    for (var i in rawMetadata['member']) {
      memberList.add(i);
    }

    ChatFrom chatFrom = ChatFrom.none;
    for (ChatFrom i in ChatFrom.values) {
      if (i.toString() == rawChatFrom) chatFrom = i;
    }

    metadata = ChatMetadata(
      isDone: rawMetadata['isDone'],
      member: memberList,
      chatFrom: chatFrom,
      suggestionIdx: rawMetadata['suggestionIdx'],
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
        '"chatFrom"': '"${metadata.chatFrom}"',
        '"suggestionIdx"': metadata.suggestionIdx,
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
    required this.chatFrom,
    required this.suggestionIdx,
  });

  final List<int> member;
  final bool isDone;
  final ChatFrom chatFrom;
  final int suggestionIdx;

  @override
  String toString() {
    debugPrint("""
    {
      member: $member,
      isDone: $isDone,
      chatFrom: $chatFrom,
      suggestionIdx: $suggestionIdx,
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
    debugPrint("""
    {
      senderId: $senderId,
      timestamp: $timestamp,
      msg: $msg,
    }
    """);
    return super.toString();
  }
}

enum ChatFrom {
  suggestion,
  community,
  none,
}

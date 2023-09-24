import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

enum ChatType { message, clear, delete }

class Chat extends Equatable {
  final String id;
  final String roomId;
  final int userNumber;
  final DateTime date;
  final String msg;
  final ChatType type;

  const Chat({
    required this.id,
    required this.roomId,
    required this.userNumber,
    required this.date,
    required this.msg,
    required this.type,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        roomId: json["room_id"],
        userNumber: json["user_number"] as int,
        date: (json["date"] as Timestamp).toDate().toLocal(),
        msg: json["msg"],
        type: _stringToChatType(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
        "user_number": userNumber,
        "date": date.toIso8601String(),
        "msg": msg,
        "type": _chatTypeToString(type),
      };

  static ChatType _stringToChatType(String type) {
    switch (type) {
      case "msg":
        return ChatType.message;
      case "clear":
        return ChatType.clear;
      case "delete":
        return ChatType.delete;
      default:
        throw ArgumentError("Invalid chat type string: $type");
    }
  }

  static String _chatTypeToString(ChatType type) {
    switch (type) {
      case ChatType.message:
        return "msg";
      case ChatType.clear:
        return "clear";
      case ChatType.delete:
        return "delete";
      default:
        throw ArgumentError("Invalid chat type: $type");
    }
  }

  @override
  List<Object?> get props => [id, roomId, userNumber, date, msg, type];
}

String chatToJson(Chat data) => json.encode(data.toJson());

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

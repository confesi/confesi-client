import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String id;
  final String roomId;
  final int userNumber;
  final DateTime date;
  final String msg;

  const Chat({
    required this.id,
    required this.roomId,
    required this.userNumber,
    required this.date,
    required this.msg,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json["id"],
        roomId: json["room_id"],
        userNumber: json["user_number"] as int,
        date: (json["date"] as Timestamp).toDate().toLocal(),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "room_id": roomId,
        "user_number": userNumber,
        "date": date.toIso8601String(),
        "msg": msg,
      };

  @override
  List<Object?> get props => [id, roomId, userNumber, date, msg];
}

String chatToJson(Chat data) => json.encode(data.toJson());

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

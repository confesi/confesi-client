import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String roomId;
  final int userNumber; // Added
  final DateTime date;
  final String msg;

  const Chat({
    required this.roomId,
    required this.userNumber, // Added
    required this.date,
    required this.msg,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        roomId: json["room_id"],
        userNumber: json["user_number"] as int, // Added
        date: (json["date"] as Timestamp).toDate().toLocal(),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "room_id": roomId,
        "user_number": userNumber, // Added
        "date": date.toIso8601String(),
        "msg": msg,
      };

  @override
  List<Object?> get props => [roomId, userNumber, date, msg]; // Added userNumber
}

String chatToJson(Chat data) => json.encode(data.toJson());

Chat chatFromJson(String str) => Chat.fromJson(json.decode(str));

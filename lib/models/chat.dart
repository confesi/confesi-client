// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'encrypted_id.dart';

Chat roomFromJson(String str) => Chat.fromJson(json.decode(str));

String roomToJson(Chat data) => json.encode(data.toJson());

class Chat extends Equatable {
  EncryptedId id;
  EncryptedId roomId;
  String userId;
  DateTime date;

  Chat({
    required this.id,
    required this.roomId,
    required this.userId,
    required this.date,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: EncryptedId.fromJson(json["id"]),
        roomId: EncryptedId.fromJson(json["room_id"]),
        userId: json["user_id"],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id.toJson(),
        "room_id": roomId.toJson(),
        "user_id": userId,
        "date": date.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, roomId, userId, date];
}

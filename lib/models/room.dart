// To parse this JSON data, do
//
//     final room = roomFromJson(jsonString);

import 'dart:convert';

import 'package:confesi/models/encrypted_id.dart';
import 'package:equatable/equatable.dart';

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

String roomToJson(Room data) => json.encode(data.toJson());

class Room extends Equatable {
  EncryptedId id;
  String userCreator;
  String userOther;
  String name;
  DateTime lastMsg;

  Room({
    required this.id,
    required this.userCreator,
    required this.userOther,
    required this.name,
    required this.lastMsg,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        id: EncryptedId.fromJson(json["id"]),
        userCreator: json["user_creator"],
        userOther: json["user_other"],
        name: json["name"],
        lastMsg: DateTime.parse(json["last_msg"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id.toJson(),
        "user_creator": userCreator,
        "user_other": userOther,
        "name": name,
        "last_msg": lastMsg.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, userCreator, userOther, name, lastMsg];
}

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:confesi/models/chat.dart';
import 'package:ordered_set/ordered_set.dart';

class Room extends Equatable {
  final String userId;
  final String name;
  final String roomId;
  final DateTime lastMsg;
  final int postId;
  final int userNumber;
  final Chat? recentChat;

  const Room({
    required this.userId,
    required this.name,
    required this.roomId,
    required this.lastMsg,
    required this.postId,
    required this.userNumber,
    required this.recentChat,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        userId: json["user_id"],
        name: json["name"],
        roomId: json["room_id"],
        lastMsg: (json["last_msg"] as Timestamp).toDate().toLocal(),
        postId: json["post_id"],
        userNumber: json["user_number"],
        recentChat: json["recent_chat"] == null ? null : Chat.fromJson(json["recent_chat"] as Map<String, dynamic>),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "room_id": roomId,
        "last_msg": Timestamp.fromDate(lastMsg.toUtc()),
        "post_id": postId,
        "user_number": userNumber,
        "recent_chat": recentChat?.toJson(),
      };

  @override
  List<Object?> get props => [userId, name, roomId, lastMsg, postId, userNumber, recentChat];

  Room copyWith({
    String? userId,
    String? name,
    String? roomId,
    DateTime? lastMsg,
    int? postId,
    int? userNumber,
    Chat? recentChat,
  }) {
    return Room(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      roomId: roomId ?? this.roomId,
      lastMsg: lastMsg ?? this.lastMsg,
      postId: postId ?? this.postId,
      userNumber: userNumber ?? this.userNumber,
      recentChat: recentChat ?? this.recentChat,
    );
  }
}

String roomToJson(Room data) => json.encode(data.toJson());

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

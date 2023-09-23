import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confesi/core/types/data.dart';
import 'package:dartz/dartz.dart';
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
  final DateTime? read;

  const Room({
    required this.userId,
    required this.name,
    required this.roomId,
    required this.lastMsg,
    required this.postId,
    required this.userNumber,
    required this.recentChat,
    required this.read,
  });

  // toString
  @override
  String toString() {
    return 'Room(userId: $userId, name: $name, roomId: $roomId, lastMsg: $lastMsg, postId: $postId, userNumber: $userNumber, recentChat: $recentChat, read: $read)';
  }

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        userId: json["user_id"],
        name: json["name"],
        roomId: json["room_id"],
        lastMsg: (json["last_msg"] as Timestamp).toDate().toLocal(),
        postId: json["post_id"],
        userNumber: json["user_number"],
        recentChat: json["recent_chat"] == null ? null : Chat.fromJson(json["recent_chat"] as Map<String, dynamic>),
        read: json["read"] != null ? (json["read"] as Timestamp).toDate().toLocal() : null, // added this new field
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "room_id": roomId,
        "last_msg": Timestamp.fromDate(lastMsg.toUtc()),
        "post_id": postId,
        "user_number": userNumber,
        "recent_chat": recentChat?.toJson(),
        "read": read ?? Timestamp.fromDate(read!.toUtc()),
      };

  @override
  List<Object?> get props => [userId, name, roomId, lastMsg, postId, userNumber, recentChat, read];

  bool onlyDifferByRead(Room other) {
    return this.userId == other.userId &&
        this.name == other.name &&
        this.roomId == other.roomId &&
        this.lastMsg == other.lastMsg &&
        this.postId == other.postId &&
        this.userNumber == other.userNumber &&
        this.recentChat == other.recentChat &&
        this.read != other.read; // Ensure only 'read' is different
  }

  Room copyWith({
    String? userId,
    String? name,
    String? roomId,
    DateTime? lastMsg,
    int? postId,
    int? userNumber,
    Chat? recentChat,
    Either<Empty, DateTime>? read, // added this new field
  }) {
    return Room(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      roomId: roomId ?? this.roomId,
      lastMsg: lastMsg ?? this.lastMsg,
      postId: postId ?? this.postId,
      userNumber: userNumber ?? this.userNumber,
      recentChat: recentChat ?? this.recentChat,
      read: read is Either ? read?.fold((e) => null, (dt) => dt) : this.read, // updated this line
    );
  }
}

String roomToJson(Room data) => json.encode(data.toJson());

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

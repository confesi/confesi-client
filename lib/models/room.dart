import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:confesi/models/chat.dart'; // Assuming you have the Chat model in this path.

class Room extends Equatable {
  final String userId;      // Added
  final String name;
  final String roomId;     // Changed from 'id'
  final DateTime lastMsg;
  final int postId;
  final int userNumber;    // Added
  final List<Chat> chats;

  const Room({
    required this.userId,  // Added
    required this.name,
    required this.roomId,  // Changed
    required this.lastMsg,
    required this.postId,
    required this.userNumber,  // Added
    required this.chats,
  });

  factory Room.fromJson(Map<String, dynamic> json) => Room(
        userId: json["user_id"], // Added
        name: json["name"],
        roomId: json["room_id"], // Changed
        lastMsg: (json["last_msg"] as Timestamp).toDate().toLocal(),
        postId: json["post_id"] as int,
        userNumber: json["user_number"] as int, // Added
        chats: const [],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,   // Added
        "name": name,
        "room_id": roomId,   // Changed
        "last_msg": lastMsg.toIso8601String(),
        "post_id": postId,
        "user_number": userNumber, // Added
        "chats": chats.map((chat) => chat.toJson()).toList(),
      };

  @override
  List<Object?> get props => [
        userId, name, roomId, lastMsg, postId, userNumber, chats
      ];

  Room copyWith({
    String? userId, // Added
    String? name,
    String? roomId, // Changed
    DateTime? lastMsg,
    int? postId,
    int? userNumber, // Added
    List<Chat>? chats,
  }) {
    return Room(
      userId: userId ?? this.userId, // Added
      name: name ?? this.name,
      roomId: roomId ?? this.roomId, // Changed
      lastMsg: lastMsg ?? this.lastMsg,
      postId: postId ?? this.postId,
      userNumber: userNumber ?? this.userNumber, // Added
      chats: chats ?? this.chats,
    );
  }
}

String roomToJson(Room data) => json.encode(data.toJson());

Room roomFromJson(String str) => Room.fromJson(json.decode(str));

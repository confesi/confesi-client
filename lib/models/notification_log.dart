// To parse this JSON data, do
//
//     final notificationLog = notificationLogFromJson(jsonString);

import 'dart:convert';

NotificationLog notificationLogFromJson(String str) => NotificationLog.fromJson(json.decode(str));

String notificationLogToJson(NotificationLog data) => json.encode(data.toJson());

class NotificationLog {
  List<ServerNoti> notifications;
  int? next;

  NotificationLog({
    required this.notifications,
    required this.next,
  });

  factory NotificationLog.fromJson(Map<String, dynamic> json) => NotificationLog(
        notifications: List<ServerNoti>.from(json["notifications"].map((x) => ServerNoti.fromJson(x))),
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "notifications": List<dynamic>.from(notifications.map((x) => x.toJson())),
        "next": next,
      };
}

class ServerNoti {
  String id;
  String title;
  String body;
  Map<String, dynamic> data;
  int createdAt;
  bool read;

  ServerNoti({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
    required this.createdAt,
    required this.read,
  });

  factory ServerNoti.fromJson(Map<String, dynamic> j) => ServerNoti(
        id: j["id"],
        title: j["title"],
        body: j["body"],
        data: Map.fromEntries(
          (json.decode(j["data"]) as Map<String, dynamic>)
              .entries
              .map((entry) => MapEntry<String, dynamic>(entry.key.toString(), entry.value))
              .toList(),
        ),
        createdAt: j["created_at"],
        read: j["read"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "body": body,
        "data": data,
        "created_at": createdAt,
        "read": read,
      };
}

// To parse this JSON data, do
//
//     final encryptedId = encryptedIdFromJson(jsonString);

import 'dart:convert';

EncryptedId encryptedIdFromJson(String str) => EncryptedId.fromJson(json.decode(str));

String encryptedIdToJson(EncryptedId data) => json.encode(data.toJson());

class EncryptedId implements Comparable<EncryptedId> {
  /// unique id (used for CLIENT unique checking)
  String uid;

  /// masked id (this is for SERVER communication)
  String mid;

  EncryptedId({
    required this.uid,
    required this.mid,
  });

  factory EncryptedId.fromJson(Map<String, dynamic> json) => EncryptedId(
        uid: json["hash"],
        mid: json["masked"],
      );

  Map<String, dynamic> toJson() => {
        "hash": uid,
        "masked": mid,
      };

  @override
  int get hashCode => uid.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is EncryptedId) {
      return this.uid == other.uid;
    }
    return false;
  }

  @override
  int compareTo(EncryptedId other) {
    return uid.compareTo(other.uid);
  }

  @override
  String toString() {
    return 'EncryptedId{uid: $uid, mid: $mid}';
  }
}

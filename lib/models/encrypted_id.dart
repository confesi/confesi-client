// To parse this JSON data, do
//
//     final encryptedId = encryptedIdFromJson(jsonString);

import 'dart:convert';

EncryptedId encryptedIdFromJson(String str) => EncryptedId.fromJson(json.decode(str));

String encryptedIdToJson(EncryptedId data) => json.encode(data.toJson());

class EncryptedId {
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

  // this is since `mid` can be different
  @override
  bool operator ==(Object other) {
    if (other is EncryptedId) {
      return this.uid == other.uid;
    }
    return false;
  }
}

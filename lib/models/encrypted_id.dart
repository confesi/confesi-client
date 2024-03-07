// To parse this JSON data, do
//
//     final encryptedId = encryptedIdFromJson(jsonString);

import 'dart:convert';

EncryptedId encryptedIdFromJson(String str) => EncryptedId.fromJson(json.decode(str));

String encryptedIdToJson(EncryptedId data) => json.encode(data.toJson());

class EncryptedId {
  String eid;

  EncryptedId({
    required this.eid,
  });

  factory EncryptedId.fromJson(String json) => EncryptedId(
        eid: json,
      );

  Map<String, dynamic> toJson() => {
        "id": eid,
      };

  @override
  String toString() {
    return eid;
  }
}

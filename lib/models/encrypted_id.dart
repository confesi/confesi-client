// To parse this JSON data, do
//
//     final encryptedId = encryptedIdFromJson(jsonString);

import 'dart:convert';

EncryptedId encryptedIdFromJson(String str) => EncryptedId.fromJson(json.decode(str));

String encryptedIdToJson(EncryptedId data) => json.encode(data.toJson());

class EncryptedId {
  String hash;
  String masked;

  EncryptedId({
    required this.hash,
    required this.masked,
  });

  factory EncryptedId.fromJson(Map<String, dynamic> json) => EncryptedId(
        hash: json["hash"],
        masked: json["masked"],
      );

  Map<String, dynamic> toJson() => {
        "hash": hash,
        "masked": masked,
      };
}

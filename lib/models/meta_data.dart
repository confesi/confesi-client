// To parse this JSON data, do
//
//     final metaData = metaDataFromJson(jsonString);

import 'dart:convert';

MetaData metaDataFromJson(String str) => MetaData.fromJson(json.decode(str));

class MetaData {
  int userVote;
  bool owner;
  bool saved;
  List<String> emojis;

  MetaData({
    required this.userVote,
    required this.owner,
    required this.saved,
    required this.emojis,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        userVote: json["user_vote"],
        owner: json["owner"],
        saved: json["saved"],
        emojis: List<String>.from(json["emojis"].map((x) => x)),
      );
}

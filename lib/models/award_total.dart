// To parse this JSON data, do
//
//     final awardTotal = awardTotalFromJson(jsonString);

import 'dart:convert';

import 'package:confesi/models/award_type.dart';
import 'package:confesi/models/encrypted_id.dart';

AwardTotal awardTotalFromJson(String str) => AwardTotal.fromJson(json.decode(str));

String awardTotalToJson(AwardTotal data) => json.encode(data.toJson());

class AwardTotal {
  EncryptedId id;
  AwardType awardType;
  int total;

  AwardTotal({
    required this.id,
    required this.awardType,
    required this.total,
  });

  factory AwardTotal.fromJson(Map<String, dynamic> json) => AwardTotal(
        id: EncryptedId.fromJson(json["id"]),
        awardType: AwardType.fromJson(json["award_type"]),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toJson(),
        "award_type": awardType.toJson(),
        "total": total,
      };
}

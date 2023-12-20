// To parse this JSON data, do
//
//     final awardType = awardTypeFromJson(jsonString);

import 'dart:convert';

AwardType awardTypeFromJson(String str) => AwardType.fromJson(json.decode(str));

String awardTypeToJson(AwardType data) => json.encode(data.toJson());

class AwardType {
  String name;
  String description;
  String icon;

  AwardType({
    required this.name,
    required this.description,
    required this.icon,
  });

  factory AwardType.fromJson(Map<String, dynamic> json) => AwardType(
        name: json["name"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "icon": icon,
      };
}

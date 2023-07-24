import '../../../domain/create_post/entities/draft_post_entity.dart';

class DraftPostModel extends DraftPostEntity {
  const DraftPostModel({
    required String title,
    required String body,
  }) : super(
          title: title,
          body: body,
        );

  factory DraftPostModel.fromJson(dynamic json) {
    return DraftPostModel(title: json["title"], body: json["body"]);
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
      };
}

import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';

class DraftPostModel extends DraftPostEntity {
  const DraftPostModel({
    required String title,
    required String body,
    required String? repliedPostId,
    required String? repliedPostTitle,
    required String? repliedPostBody,
  }) : super(
          repliedPostId: repliedPostId,
          repliedPostBody: repliedPostBody,
          repliedPostTitle: repliedPostTitle,
          title: title,
          body: body,
        );

  factory DraftPostModel.fromJson(dynamic json) {
    return DraftPostModel(
        title: json["title"],
        body: json["body"],
        repliedPostId: json["repliedPostId"],
        repliedPostBody: json["repliedPostBody"],
        repliedPostTitle: json["repliedPostTitle"]);
  }

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": body,
        "repliedPostId": repliedPostId,
        "repliedPostTitle": repliedPostTitle,
        "repliedPostBody": repliedPostBody,
      };
}

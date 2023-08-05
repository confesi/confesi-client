// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<CommentGroup> commentFromJson(String str) =>
    List<CommentGroup>.from(json.decode(str).map((x) => CommentGroup.fromJson(x)));

class CommentGroup {
  CommentWithMetadata root;
  List<CommentWithMetadata>? replies;
  int? next;

  CommentGroup({
    required this.root,
    this.replies,
    this.next,
  });
  factory CommentGroup.fromJson(Map<String, dynamic> json) {
    List<CommentWithMetadata> replies = [];
    if (json["replies"] != null) {
      replies = List<CommentWithMetadata>.from(json["replies"]!.map((x) => CommentWithMetadata.fromJson(x)));
    }

    int? next = json["next"] as int?;

    return CommentGroup(
      root: CommentWithMetadata.fromJson(json["root"]),
      replies: replies,
      next: next,
    );
  }
}

class CommentWithMetadata {
  Comment comment;
  int userVote;
  bool owner;

  CommentWithMetadata({
    required this.comment,
    required this.userVote,
    required this.owner,
  });

  factory CommentWithMetadata.fromJson(Map<String, dynamic> json) => CommentWithMetadata(
        comment: Comment.fromJson(json["comment"]),
        userVote: json["user_vote"],
        owner: json["owner"],
      );
}

class Comment {
  int id;
  int createdAt;
  int updatedAt;
  int postId;
  int? numericalUser;
  int? numericalReplyingUser;
  bool numericalUserIsOp;
  bool numericalReplyingUserIsOp;
  int? parentRoot;
  int childrenCount;
  String content;
  int downvote;
  int upvote;
  num trendingScore;
  bool hidden;
  bool edited;

  Comment({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.postId,
    this.numericalUser,
    this.numericalReplyingUser,
    required this.numericalUserIsOp,
    required this.numericalReplyingUserIsOp,
    this.parentRoot,
    required this.childrenCount,
    required this.content,
    required this.downvote,
    required this.upvote,
    required this.trendingScore,
    required this.hidden,
    required this.edited,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        postId: json["post_id"],
        numericalUser: json["numerical_user"],
        numericalReplyingUser: json["numerical_replying_user"],
        numericalUserIsOp: json["numerical_user_is_op"],
        numericalReplyingUserIsOp: json["numerical_replying_user_is_op"],
        parentRoot: json["parent_root"],
        childrenCount: json["children_count"],
        content: json["content"],
        downvote: json["downvote"],
        upvote: json["upvote"],
        trendingScore: json["trending_score"],
        hidden: json["hidden"],
        edited: json["edited"],
      );
}

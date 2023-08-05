// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<Comment> commentFromJson(String str) => List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

class Comment {
  Root root;
  List<Root>? replies;
  int? next;

  Comment({
    required this.root,
    this.replies,
    this.next,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        root: Root.fromJson(json["root"]),
        replies: json["replies"] == null ? [] : List<Root>.from(json["replies"]!.map((x) => Root.fromJson(x))),
        next: json["next"],
      );
}

class Root {
  CommentClass comment;
  int userVote;
  bool owner;

  Root({
    required this.comment,
    required this.userVote,
    required this.owner,
  });

  factory Root.fromJson(Map<String, dynamic> json) => Root(
        comment: CommentClass.fromJson(json["comment"]),
        userVote: json["user_vote"],
        owner: json["owner"],
      );
}

class CommentClass {
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

  CommentClass({
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

  factory CommentClass.fromJson(Map<String, dynamic> json) => CommentClass(
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

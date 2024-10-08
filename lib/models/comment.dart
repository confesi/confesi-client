// To parse this JSON data, do
//
//     final comment = commentFromJson(jsonString);

import 'dart:convert';

List<CommentGroup> commentFromJson(String str) =>
    List<CommentGroup>.from(json.decode(str).map((x) => CommentGroup.fromJson(x)));

String commentToJson(List<CommentGroup> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CommentGroup {
  CommentWithMetadata root;
  List<CommentWithMetadata> replies;
  int? next;

  CommentGroup({
    required this.root,
    required this.replies,
    required this.next,
  });

  factory CommentGroup.fromJson(Map<String, dynamic> json) => CommentGroup(
        root: CommentWithMetadata.fromJson(json["root"]),
        replies: List<CommentWithMetadata>.from(json["replies"].map((x) => CommentWithMetadata.fromJson(x))),
        next: json["next"],
      );

  Map<String, dynamic> toJson() => {
        "root": root.toJson(),
        "replies": List<dynamic>.from(replies.map((x) => x.toJson())),
        "next": next,
      };
}

class CommentWithMetadata {
  Comment comment;
  int userVote;
  bool owner;
  bool saved;
  bool reported;

  CommentWithMetadata({
    required this.comment,
    required this.userVote,
    required this.owner,
    required this.saved,
    required this.reported,
  });

  factory CommentWithMetadata.fromJson(Map<String, dynamic> json) => CommentWithMetadata(
        comment: Comment.fromJson(json["comment"]),
        userVote: json["user_vote"],
        reported: json["reported"],
        saved: json["saved"],
        owner: json["owner"],
      );

  Map<String, dynamic> toJson() => {
        "comment": comment.toJson(),
        "user_vote": userVote,
        "owner": owner,
      };

  // tostring
  @override
  String toString() {
    return 'CommentWithMetadata{comment: $comment, userVote: $userVote, owner: $owner}';
  }

  // copyWith method
  CommentWithMetadata copyWith({
    Comment? comment,
    int? userVote,
    bool? owner,
    bool? saved,
    bool? reported,
  }) {
    return CommentWithMetadata(
      comment: comment ?? this.comment,
      userVote: userVote ?? this.userVote,
      owner: owner ?? this.owner,
      saved: saved ?? this.saved,
      reported: reported ?? this.reported,
    );
  }
}

class Comment {
  String id;
  int createdAt;
  int updatedAt;
  String postId;
  int? numericalUser;
  int? numericalReplyingUser;
  bool numericalUserIsOp;
  bool numericalReplyingUserIsOp;
  String? parentRootId;
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
    required this.numericalUser,
    this.numericalReplyingUser,
    required this.numericalUserIsOp,
    required this.numericalReplyingUserIsOp,
    this.parentRootId,
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
        parentRootId: json["parent_root_id"],
        childrenCount: json["children_count"],
        content: json["content"],
        downvote: json["downvote"],
        upvote: json["upvote"],
        trendingScore: json["trending_score"],
        hidden: json["hidden"],
        edited: json["edited"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "post_id": postId,
        "numerical_user": numericalUser,
        "numerical_replying_user": numericalReplyingUser,
        "numerical_user_is_op": numericalUserIsOp,
        "numerical_replying_user_is_op": numericalReplyingUserIsOp,
        "parent_root_id": parentRootId,
        "children_count": childrenCount,
        "content": content,
        "downvote": downvote,
        "upvote": upvote,
        "trending_score": trendingScore,
        "hidden": hidden,
        "edited": edited,
      };

  // copyWith method
  Comment copyWith({
    String? id,
    int? createdAt,
    int? updatedAt,
    String? postId,
    int? numericalUser,
    int? numericalReplyingUser,
    bool? numericalUserIsOp,
    bool? numericalReplyingUserIsOp,
    String? parentRootId,
    int? childrenCount,
    String? content,
    int? downvote,
    int? upvote,
    num? trendingScore,
    bool? hidden,
    bool? edited,
  }) {
    return Comment(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      postId: postId ?? this.postId,
      numericalUser: numericalUser ?? this.numericalUser,
      numericalReplyingUser: numericalReplyingUser ?? this.numericalReplyingUser,
      numericalUserIsOp: numericalUserIsOp ?? this.numericalUserIsOp,
      numericalReplyingUserIsOp: numericalReplyingUserIsOp ?? this.numericalReplyingUserIsOp,
      parentRootId: parentRootId ?? this.parentRootId,
      childrenCount: childrenCount ?? this.childrenCount,
      content: content ?? this.content,
      downvote: downvote ?? this.downvote,
      upvote: upvote ?? this.upvote,
      trendingScore: trendingScore ?? this.trendingScore,
      hidden: hidden ?? this.hidden,
      edited: edited ?? this.edited,
    );
  }

  // tostring simple
  @override
  String toString() {
    return 'Comment{id: $id, createdAt: $createdAt, updatedAt: $updatedAt, postId: $postId, numericalUser: $numericalUser, numericalReplyingUser: $numericalReplyingUser, numericalUserIsOp: $numericalUserIsOp, numericalReplyingUserIsOp: $numericalReplyingUserIsOp, parentRootId: $parentRootId, childrenCount: $childrenCount, content: $content, downvote: $downvote, upvote: $upvote, trendingScore: $trendingScore, hidden: $hidden, edited: $edited}';
  }
}

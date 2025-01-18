import 'package:navy/features/posts/model/post_model.dart';

class CommentModel {
  final int id;
  final int postId;
  final int userId;
  final int? parentId;
  final String? comment;
  final String? media;
  final String createdAt;
  final Owner user;
  final int? repliesCount;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    this.parentId,
    this.comment,
    this.media,
    required this.createdAt,
    required this.user,
    this.repliesCount,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      postId: json['post_id'],
      userId: json['user_id'],
      parentId: json['parent_id'],
      comment: json['comment'],
      media: json['media'],
      createdAt: json['created_at'],
      user: Owner.fromJson(json['user']),
      repliesCount: json['replies_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'post_id': postId,
      'user_id': userId,
      'parent_id': parentId,
      'comment': comment,
      'media': media,
      'created_at': createdAt,
      'user': user.toJson(),
      'replies_count': repliesCount,
    };
  }
}

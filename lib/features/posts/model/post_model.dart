import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 2)
class PostResponse {
  @HiveField(0)
  final String responseCode;
  @HiveField(1)
  final String message;
  @HiveField(2)
  final List<Post> content;
  @HiveField(3)
  final List<dynamic> errors;
  @HiveField(4)
  final Pagination pagination;

  PostResponse({
    required this.responseCode,
    required this.message,
    required this.content,
    required this.errors,
    required this.pagination,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      responseCode: json['response_code'],
      message: json['message'],
      content: (json['content'] as List).map((e) => Post.fromJson(e)).toList(),
      errors: json['errors'],
      pagination: Pagination.fromJson(json['pagination']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response_code': responseCode,
      'message': message,
      'content': content.map((e) => e.toJson()).toList(),
      'errors': errors,
      'pagination': pagination.toJson(),
    };
  }
}

@HiveType(typeId: 3)
class Post {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String content;
  @HiveField(2)
  final String visibility;
  @HiveField(3)
  final String location;
  @HiveField(4)
  final String createdAt;
  @HiveField(5)
  final String updatedAt;
  @HiveField(6)
  final int reactionsCount;
  @HiveField(7)
  final int commentsCount;
  @HiveField(8)
  final int sharesCount;
  @HiveField(9)
  final bool selfReacted;
  @HiveField(10)
  final String? selfReactionType;
  @HiveField(11)
  final List<String> media;
  @HiveField(12)
  final Owner owner;

  Post({
    required this.id,
    required this.content,
    required this.visibility,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.reactionsCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.selfReacted,
    this.selfReactionType,
    required this.media,
    required this.owner,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      content: json['content'],
      visibility: json['visibility'],
      location: json['location'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      reactionsCount: json['reactions_count'],
      commentsCount: json['comments_count'],
      sharesCount: json['shares_count'],
      selfReacted: json['self_reacted'],
      selfReactionType: json['self_reaction_type'],
      media: List<String>.from(json['media']),
      owner: Owner.fromJson(json['owner']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'visibility': visibility,
      'location': location,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'reactions_count': reactionsCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'self_reacted': selfReacted,
      'self_reaction_type': selfReactionType,
      'media': media,
      'owner': owner.toJson(),
    };
  }
}

@HiveType(typeId: 4)
class Owner {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String avatar;

  Owner({required this.id, required this.name, required this.avatar});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
    };
  }
}

@HiveType(typeId: 5)
class Pagination {
  @HiveField(0)
  final int currentPage;
  @HiveField(1)
  final int lastPage;
  @HiveField(2)
  final int perPage;
  @HiveField(3)
  final int total;

  Pagination({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      perPage: json['per_page'],
      total: json['total'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'last_page': lastPage,
      'per_page': perPage,
      'total': total,
    };
  }
}

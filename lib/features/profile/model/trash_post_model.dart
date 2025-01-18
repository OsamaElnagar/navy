class TrashPost {
  final int id;
  final String content;
  final String visibility;
  final String? location;
  final String createdAt;
  final String updatedAt;
  final List<String> media;
  final int? reactionsCount;
  final int? commentsCount;
  final int? sharesCount;
  final bool selfReacted;
  final String? selfReactionType;

  TrashPost({
    required this.id,
    required this.content,
    required this.visibility,
    this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.media,
    this.reactionsCount,
    this.commentsCount,
    this.sharesCount,
    required this.selfReacted,
    this.selfReactionType,
  });

  factory TrashPost.fromJson(Map<String, dynamic> json) {
    return TrashPost(
      id: json['id'],
      content: json['content'],
      visibility: json['visibility'],
      location: json['location'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      media: List<String>.from(json['media'] ?? []),
      reactionsCount: json['reactions_count'],
      commentsCount: json['comments_count'],
      sharesCount: json['shares_count'],
      selfReacted: json['self_reacted'] ?? false,
      selfReactionType: json['self_reaction_type'],
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
      'media': media,
      'reactions_count': reactionsCount,
      'comments_count': commentsCount,
      'shares_count': sharesCount,
      'self_reacted': selfReacted,
      'self_reaction_type': selfReactionType,
    };
  }
}

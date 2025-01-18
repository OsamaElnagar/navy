class Friend {
  final int id;
  final String name;
  final String? avatar;
  final String acceptedAt;
  final String requestedAt;

  Friend({
    required this.id,
    required this.name,
    this.avatar,
    required this.acceptedAt,
    required this.requestedAt,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      acceptedAt: json['accepted_at'],
      requestedAt: json['requested_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'accepted_at': acceptedAt,
      'requested_at': requestedAt,
    };
  }
}

import 'package:hive/hive.dart';

part 'user_response.g.dart';

@HiveType(typeId: 0)
class UserResponse extends HiveObject {
  @HiveField(0)
  final User user;

  @HiveField(1)
  final String token;

  UserResponse({
    required this.user,
    required this.token,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }

  UserResponse copyWith({
    User? user,
    String? token,
  }) {
    return UserResponse(
      user: user ?? this.user,
      token: token ?? this.token,
    );
  }
}

@HiveType(typeId: 1)
class User extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String username;

  @HiveField(2)
  final String email;

  @HiveField(4)
  final String name;

  @HiveField(5)
  final String? bio;

  @HiveField(6)
  final String? avatar;

  @HiveField(7)
  final String? location;

  @HiveField(8)
  final String? website;

  @HiveField(9)
  final String? phone;

  @HiveField(10)
  final DateTime? dateOfBirth;

  @HiveField(11)
  final bool isVerified;

  @HiveField(12)
  final DateTime createdAt;

  @HiveField(13)
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.name,
    this.bio,
    this.avatar,
    this.location,
    this.website,
    this.phone,
    this.dateOfBirth,
    required this.isVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      username: json['username'],
      email: json['email'],
      name: json['name'],
      bio: json['bio'],
      avatar: json['avatar'],
      location: json['location'],
      website: json['website'],
      phone: json['phone'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.parse(json['date_of_birth'])
          : null,
      isVerified: json['is_verified'] == 1,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'name': name,
      'bio': bio,
      'avatar': avatar,
      'location': location,
      'website': website,
      'phone': phone,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'is_verified': isVerified ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    int? id,
    String? username,
    String? email,
    String? name,
    String? bio,
    String? avatar,
    String? location,
    String? website,
    String? phone,
    DateTime? dateOfBirth,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      website: website ?? this.website,
      phone: phone ?? this.phone,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

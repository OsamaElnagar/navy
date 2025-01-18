class FriendshipResponse {
  final String message;
  final String status;
  final String type;
  final List<String> errors;

  FriendshipResponse({
    this.message = '',
    this.status = '',
    this.type = '',
    this.errors = const [],
  });

  factory FriendshipResponse.fromJson(Map<String, dynamic> json) {
    // Check if this is a status response
    if (json['status'] != null && json['type'] != null) {
      return FriendshipResponse(
        status: json['status'],
        type: json['type'],
      );
    }

    // Otherwise, handle the regular response format
    return FriendshipResponse(
      message: json['content']?['message'] ?? '',
      status: json['content']?['status'] ?? '',
      type: json['content']?['type'] ?? '',
      errors: List<String>.from(json['errors'] ?? []),
    );
  }

  bool get hasErrors => errors.isNotEmpty;
  String get firstError => errors.isNotEmpty ? errors.first : '';
}

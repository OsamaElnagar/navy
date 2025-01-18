class NotificationModel {
  final String type;
  final String message;
  final Map<String, dynamic> data;
  final DateTime createdAt;

  NotificationModel({
    required this.type,
    required this.message,
    required this.data,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      type: json['type'],
      message: json['message'],
      data: json['data'] ?? {},
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

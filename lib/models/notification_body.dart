
class NotificationBody {
  String? title;
  String? body;
  String? bookingId;
  String? channelId;
  String? postId;
  String? type;
  String? notificationImage;
  String? userProfileImage;
  String? userPhone;
  String? userName;
  String? userType;

  NotificationBody(
      {this.title, this.body, this.bookingId, this.type, this.notificationImage,this.userProfileImage,this.channelId,this.userName,this.userPhone,this.userType});

  NotificationBody.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    bookingId = json['booking_id'];
    channelId = json['channel_id'];
    postId = json['post_id'];
    type = json['type'];
    notificationImage = json['image'];
    userProfileImage = json['user_image'];
    userType = json['user_type'];
    userName = json['user_name'];
    userPhone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['booking_id'] = bookingId;
    data['channel_id'] = channelId;
    data['post_id'] = postId;
    data['type'] = type;
    data['image'] = notificationImage;
    data['user_image'] = userProfileImage;
    data['user_name'] = userName;
    data['user_phone'] = userPhone;
    data['user_type'] = userType;
    return data;
  }
}

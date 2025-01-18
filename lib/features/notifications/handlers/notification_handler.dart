abstract class NotificationHandler {
  bool canHandle(String type);
  void handleNotification(
    Map<String, dynamic> payload, {
    bool requireNavigation,
  });
  String getRelevantRoute(Map<String, dynamic> payload);
}

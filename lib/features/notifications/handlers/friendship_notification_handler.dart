import 'package:get/get.dart';
import 'package:navy/core/helpers/route_helper.dart';
import 'package:navy/features/notifications/handlers/notification_handler.dart';
import 'package:navy/features/profile/controller/visit_profile_controller.dart';
import 'package:pretty_logger/pretty_logger.dart';

class FriendshipNotificationHandler implements NotificationHandler {
  static const _acceptedType = 'friend_request_accepted';
  static const _receivedType = 'friend_request_receieved';

  @override
  bool canHandle(String type) {
    return type == _acceptedType || type == _receivedType;
  }

  int _getRelevantId(Map<String, dynamic> payload) {
    final type = payload['notification_type'] as String;
    return type == _acceptedType
        ? int.parse(payload['accepter_id'])
        : int.parse(payload['sender_id']);
  }

  @override
  String getRelevantRoute(Map<String, dynamic> payload) {
    return RouteHelper.getVisitProfileRoute(_getRelevantId(payload),
        fromNotification: true);
  }

  @override
  void handleNotification(Map<String, dynamic> payload,
      {bool requireNavigation = true}) {
    final id = _getRelevantId(payload);
    final currentRoute = Get.currentRoute;
    String targetRoute =
        RouteHelper.getVisitProfileRoute(id, fromNotification: false);

    final bool sameRoute = currentRoute == targetRoute;

    PLog.cyan("currentRoute: $currentRoute\n");
    PLog.cyan("targetRoute: $targetRoute\n");
    PLog.cyan("sameRoute?: $sameRoute\n");

    if (sameRoute) {
      if (Get.isRegistered<VisitProfileController>()) {
        Get.find<VisitProfileController>().checkFriendshipStatus(id);
      }
      return;
    }
    if (requireNavigation) {
      targetRoute =
          RouteHelper.getVisitProfileRoute(id, fromNotification: true);
      PLog.cyan('Enterd the require navigation scope!');
      Get.toNamed(
        targetRoute,
      );
    }
  }
}

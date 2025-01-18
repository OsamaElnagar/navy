import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:navy/features/notifications/handlers/chat_notification_handler.dart';
import 'package:navy/features/notifications/handlers/notification_handler.dart';
import 'package:pretty_logger/pretty_logger.dart';
import 'package:get/get.dart';

import '../core/helpers/route_helper.dart';
import '../features/chat/controller/chat_room_controller.dart';
import '../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class NotificationService {
  final messaging = FirebaseMessaging.instance;
  final localNotifications = FlutterLocalNotificationsPlugin();
  final List<NotificationHandler> _handlers;
  RemoteMessage? _pendingNotification;

  NotificationService({required List<NotificationHandler> handlers})
      : _handlers = handlers;

  Future<void> initialize() async {
    await messaging.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await _setupLocalNotifications();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      _pendingNotification = initialMessage;
    }
  }

  Future<void> _setupLocalNotifications() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );

    await localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await localNotifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        PLog.cyan("Local notification tapped");
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          _handleNotificationData(data, true);
        }
      },
    );
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notificationType = message.data['notification_type'];
    final handler = _handlers.firstWhereOrNull(
      (handler) => handler.canHandle(notificationType),
    );

    if (handler != null) {
      // Show notification unless in relevant chat room
      final notification = message.notification;
      if (notification != null &&
          !(handler is ChatNotificationHandler &&
              _isInRelevantChatRoom(message.data))) {
        localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.high,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }

      // Handle notification without navigation in foreground
      handler.handleNotification(message.data, requireNavigation: false);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    _handleNotificationData(message.data, true);
  }

  void _handleNotificationData(
      Map<String, dynamic> data, bool requireNavigation) {
    PLog.cyan("Handling notification data with navigation: $requireNavigation");
    final handler = _handlers.firstWhereOrNull(
      (handler) => handler.canHandle(data['notification_type']),
    );

    if (handler != null) {
      handler.handleNotification(data, requireNavigation: requireNavigation);
    }
  }

  void handlePendingNotification() {
    if (_pendingNotification != null) {
      _handleNotificationTap(_pendingNotification!);
      _pendingNotification = null;
    }
  }

  bool _isInRelevantChatRoom(Map<String, dynamic> data) {
    try {
      if (!Get.currentRoute.startsWith(RouteHelper.chatRoom)) return false;
      if (!Get.isRegistered<ChatRoomController>()) return false;

      final messageData = jsonDecode(data['message'] as String);
      final chatId = messageData['chat_id'] as int;
      final controller = Get.find<ChatRoomController>();

      return controller.chatId == chatId;
    } catch (e) {
      PLog.red("Error checking chat room state: $e");
      return false;
    }
  }
}

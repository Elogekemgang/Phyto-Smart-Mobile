import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {

  static final FlutterLocalNotificationsPlugin
  notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future init() async {

    const AndroidInitializationSettings
    androidSettings =
    AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const InitializationSettings
    settings =
    InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(
      settings,
    );

    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
    notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }

  }

  static Future showNotification({
    required int id,
    required String title,
    required String body,
  }) async {

    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(
      'agro_ai_channel',
      'Agro AI Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails
    details =
    NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(
      id,
      title,
      body,
      details,
    );
  }

  static Future scheduleNotification({

    required int id,

    required String title,

    required String body,

    required DateTime scheduledDate,

  }) async {

    const AndroidNotificationDetails
    androidDetails =
    AndroidNotificationDetails(
      'agro_ai_channel',
      'Agro AI Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails
    details =
    NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.zonedSchedule(

      id,

      title,

      body,

      tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      ),

      details,

      androidScheduleMode:
      AndroidScheduleMode
          .exactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation
          .absoluteTime,
    );
  }
}
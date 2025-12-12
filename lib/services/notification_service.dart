import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notifications.initialize(settings);
  }

  static Future<void> showOncePerDayOnAppOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);

    final lastShown = prefs.getString('last_notification_date');

    if (lastShown == today) return;

    const androidDetails = AndroidNotificationDetails(
      'daily_recipe',
      'Daily Recipe',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      0,
      'Recipe of the day 🍽️',
      'Don’t forget to check today’s random recipe!',
      details,
    );

    await prefs.setString('last_notification_date', today);
  }
}
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationSystem {
  FlutterLocalNotificationsPlugin plugin;

  NotificationSystem() {
    plugin = new FlutterLocalNotificationsPlugin();
    var androidSettings = new AndroidInitializationSettings('past_me_icon');
    var iosSettings = new IOSInitializationSettings();
    var settings = new InitializationSettings(androidSettings, iosSettings);
    plugin.initialize(settings);
  }

  Future show(String msg) async {
    var androidDetails = new AndroidNotificationDetails("PastMe.Reminders", "Reminders", "Scheduled Reminders");
    var iosDetails = new IOSNotificationDetails();
    NotificationDetails details = NotificationDetails(androidDetails, iosDetails);
    await plugin.show(0, "Notification", msg, details);
  }

  Future schedule(DateTime time, String msg) async {
    var androidDetails = new AndroidNotificationDetails("PastMe.Reminders", "Reminders", "Scheduled Reminders");
    var iosDetails = new IOSNotificationDetails();
    NotificationDetails details = NotificationDetails(androidDetails, iosDetails);
    await plugin.schedule(0, "Notification", msg, time, details);
  }
}
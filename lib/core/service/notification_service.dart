import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/util/constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final instance = FirebaseMessaging.instance;
  static const fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  // TODO: add your firebase server key
  static const serverKey ='';
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'growthpad', // id
    'GrowthPad', // title
    description: 'Notifications for scheduled events', // description
    importance: Importance.high,
  );

  static Future<void> initialize() async {
    var androidInitialize = const AndroidInitializationSettings('app_icon');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String? payload) {});
    tz.initializeTimeZones();
  }

  static Future<void> subscribe(String userId, String societyId) async {
    await instance.subscribeToTopic(userId);
    await instance.subscribeToTopic(societyId);
    await Get.find<SharedPreferences>().setString(Constant.spUidTopic, userId);
    await Get.find<SharedPreferences>().setString(Constant.spSidTopic, societyId);
  }

  static Future<void> unsubscribe() async {
    var userId = Get.find<SharedPreferences>().getString(Constant.spUidTopic);
    var societyId = Get.find<SharedPreferences>().getString(Constant.spSidTopic);
    await instance.unsubscribeFromTopic(userId ?? '');
    await instance.unsubscribeFromTopic(societyId ?? '');
    await Get.find<SharedPreferences>().remove(Constant.spUidTopic);
    await Get.find<SharedPreferences>().remove(Constant.spSidTopic);
  }

  static Future<void> sendNotification({
    required String topic,
    required String title,
    required String body,
  }) async {
    var jsonHeader = {
      'content-type': 'application/json',
      'authorization': 'key=$serverKey',
    };

    var jsonBody = {
      'to': '/topics/$topic',
      'notification': {'title': title, 'body': body},
    };

    Log.console('http.post.url: $fcmUrl');
    Log.console('http.post.header: ${jsonEncode(jsonHeader)}');
    Log.console('http.post.body: ${jsonEncode(jsonBody)}');

    var response = await post(
      Uri.parse(fcmUrl),
      headers: jsonHeader,
      body: jsonEncode(jsonBody),
    );

    Log.console('http.post.statusCode: ${response.statusCode}');
    Log.console('http.post.phrase: ${response.reasonPhrase}');
    Log.console('http.post.body: ${response.body}');
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime date,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(date, tz.local),
      NotificationDetails(android: AndroidNotificationDetails(channel.id, channel.name)),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}

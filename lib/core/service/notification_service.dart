import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/util/constants.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final instance = FirebaseMessaging.instance;
  static const fcmUrl = 'https://fcm.googleapis.com/fcm/send';
  static const serverKey =
      'AAAAJSeh8_o:APA91bELMf61ZOFiu1XABxmcZFUKimekIYqXIFFpb3m0c_XbV7nYUvo6aXgRtk84xtI6au7DpqEAFZhLtAGcuy5u6AR4Tk7Ey5-v84bur83PpTvezejAImRsNOwIaeWvwC9YRBTJ2xDI';

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
}

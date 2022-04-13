import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:growthpad/data/model/chat_message.dart';
import 'package:growthpad/data/model/society.dart';
import 'package:growthpad/util/constants.dart';

class ChatController {
  static Stream<List<ChatMessage>> getChatMsg(String chatId) {
    return FirebaseDatabase.instance.ref().child('chats').child(chatId).onValue.map((event) {
      List<ChatMessage> chats = [];

      for (var chat in event.snapshot.children) {
        ChatMessage temp = ChatMessage.fromJson(chat.value);
        chats.add(temp);
      }
      return chats.reversed.toList();
    });
  }

  static Future<void> sendMsg(String chatId, ChatMessage message) {
    return FirebaseDatabase.instance.ref().child('chats').child(chatId).push().set(message.toJson());
  }

  static Future<Society?> getSocietyDetails(String id) async {
    var snapshot = await FirebaseFirestore.instance.collection(Constant.cSociety).where(Constant.fsId, isEqualTo: id).get();
    if (snapshot.docs.isEmpty) return null;
    return Society.fromMap(snapshot.docs.first.data());
  }
}

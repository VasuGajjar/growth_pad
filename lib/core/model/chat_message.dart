import 'dart:convert';

class ChatMessage {
  String senderId;
  String senderName;
  String message;
  String timestamp;

  ChatMessage({
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(var json) => ChatMessage(
        senderId: json['senderId'],
        senderName: json['senderName'],
        message: json['message'],
        timestamp: json['timestamp'],
      );

  Map<String, String> toJson() => {
        'senderId': senderId,
        'senderName': senderName,
        'message': message,
        'timestamp': timestamp,
      };
}

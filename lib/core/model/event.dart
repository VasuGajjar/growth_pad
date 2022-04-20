import 'dart:convert';

import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/util/constants.dart';

class Event {
  String id;
  String sid;
  String title;
  String? description;
  bool isPaid;
  double amount;
  DateTime eventTime;
  DateTime createdAt;

  Event({
    required this.id,
    required this.sid,
    required this.title,
    required this.description,
    required this.isPaid,
    required this.amount,
    required this.eventTime,
    required this.createdAt,
  });

  factory Event.fromMap(var json) => Event(
        id: json[Constant.fsId] ?? '',
        sid: json[Constant.fsSocietyId] ?? '',
        title: json[Constant.fsTitle] ?? '',
        description: json[Constant.fsDescription],
        isPaid: json[Constant.fsIsPaid] ?? false,
        amount: json[Constant.fsAmount] ?? 0,
        eventTime: DateConverter.stringToTime(json[Constant.fsEventTime]),
        createdAt: DateConverter.stringToTime(json[Constant.fsCreateDate]),
      );

  Map<String, dynamic> toMap() => {
        Constant.fsId: id,
        Constant.fsSocietyId: sid,
        Constant.fsTitle: title,
        Constant.fsDescription: description,
        Constant.fsIsPaid: isPaid,
        Constant.fsAmount: amount,
        Constant.fsEventTime: DateConverter.timeToString(eventTime),
        Constant.fsCreateDate: DateConverter.timeToString(createdAt),
      };

  String toJson() => jsonEncode(toMap());
}

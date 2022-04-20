import 'dart:convert';

import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/util/constants.dart';

class EventPayment {
  String id;
  String userId;
  String eventId;
  double? amount;
  DateTime paymentTime;

  EventPayment({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.amount,
    required this.paymentTime,
  });

  Map<String, dynamic> toMap() => {
        Constant.fsId: id,
        Constant.fsUserId: userId,
        Constant.fsEventId: eventId,
        Constant.fsAmount: amount,
        Constant.fsPaymentTime: DateConverter.timeToString(paymentTime),
      };

  factory EventPayment.fromMap(Map<String, dynamic> map) => EventPayment(
        id: map[Constant.fsId] ?? '',
        userId: map[Constant.fsUserId] ?? '',
        eventId: map[Constant.fsEventId] ?? '',
        amount: map[Constant.fsAmount],
        paymentTime: DateConverter.stringToTime(map[Constant.fsPaymentTime]),
      );

  String toJson() => json.encode(toMap());
}

import 'dart:convert';

import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/util/constants.dart';

class Payment {
  String userId;
  String maintenanceId;
  double amount;
  bool penalty;
  DateTime paymentTime;

  Payment({
    required this.userId,
    required this.maintenanceId,
    required this.amount,
    required this.penalty,
    required this.paymentTime,
  });

  Map<String, dynamic> toMap() => {
        Constant.fsUserId: userId,
        Constant.fsMaintenanceId: maintenanceId,
        Constant.fsAmount: amount,
        Constant.fsPenalty: penalty,
        Constant.fsPaymentTime: DateConverter.timeToString(paymentTime),
      };

  factory Payment.fromMap(Map<String, dynamic> map) {
    return Payment(
      userId: map[Constant.fsUserId] ?? '',
      maintenanceId: map[Constant.fsMaintenanceId] ?? '',
      amount: map[Constant.fsAmount] ?? '',
      penalty: map[Constant.fsPenalty] ?? '',
      paymentTime: DateConverter.stringToTime(map[Constant.fsPaymentTime]),
    );
  }

  String toJson() => json.encode(toMap());
}

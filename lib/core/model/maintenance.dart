import 'dart:convert';

import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/util/constants.dart';

class Maintenance {
  String id;
  String sid;
  String month;
  String year;
  double amount;
  double penalty;
  DateTime deadLine;
  DateTime createDate;

  Maintenance({
    required this.id,
    required this.sid,
    required this.month,
    required this.year,
    required this.amount,
    required this.penalty,
    required this.deadLine,
    required this.createDate,
  });

  Map<String, dynamic> toMap() => {
        Constant.fsId: id,
        Constant.fsSocietyId: sid,
        Constant.fsMonth: month,
        Constant.fsYear: year,
        Constant.fsAmount: amount,
        Constant.fsPenalty: penalty,
        Constant.fsDeadLine: DateConverter.timeToString(deadLine),
        Constant.fsCreateDate: DateConverter.timeToString(createDate),
      };

  factory Maintenance.fromMap(Map<String, dynamic> map) {
    return Maintenance(
      id: map[Constant.fsId] ?? '',
      sid: map[Constant.fsSocietyId] ?? '',
      month: map[Constant.fsMonth] ?? '',
      year: map[Constant.fsYear] ?? '',
      amount: map[Constant.fsAmount] ?? '',
      penalty: map[Constant.fsPenalty] ?? '',
      deadLine: DateConverter.stringToTime(map[Constant.fsDeadLine]),
      createDate: DateConverter.stringToTime(map[Constant.fsCreateDate]),
    );
  }

  String toJson() => json.encode(toMap());
}

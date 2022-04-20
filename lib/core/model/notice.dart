import 'dart:convert';

import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/util/constants.dart';

class Notice {
  String docReference;
  String id;
  String sid;
  String title;
  String description;
  DateTime createdAt;

  Notice({
    this.docReference = '',
    required this.id,
    required this.sid,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory Notice.fromMap(String id, var json) => Notice(
        docReference: id,
        id: json[Constant.fsId] ?? '',
        sid: json[Constant.fsSocietyId] ?? '',
        title: json[Constant.fsTitle] ?? '',
        description: json[Constant.fsDescription] ?? '',
        createdAt: DateConverter.stringToTime(json[Constant.fsCreateDate] ?? ''),
      );

  Map<String, String> toMap() => {
        Constant.fsId: id,
        Constant.fsSocietyId: sid,
        Constant.fsTitle: title,
        Constant.fsDescription: description,
        Constant.fsCreateDate: DateConverter.timeToString(createdAt),
      };

  String toJson() => jsonEncode(toMap());
}

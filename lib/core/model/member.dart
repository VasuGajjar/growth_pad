import 'dart:convert';

import '../../util/constants.dart';

class Member {
  final String id;
  final String name;
  final String email;
  final String sid;
  final String block;
  final String houseNo;
  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.sid,
    required this.block,
    required this.houseNo,
  });

  Member copyWith({
    String? id,
    String? name,
    String? email,
    String? sid,
    String? block,
    String? houseNo,
  }) {
    return Member(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      sid: sid ?? this.sid,
      block: block ?? this.block,
      houseNo: houseNo ?? this.houseNo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.fsId: id,
      Constant.fsName: name,
      Constant.fsEmail: email,
      Constant.fsSocietyId: sid,
      Constant.fsBlock: block,
      Constant.fsHouseNumber: houseNo,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      id: map[Constant.fsId] ?? '',
      name: map[Constant.fsName] ?? '',
      email: map[Constant.fsEmail] ?? '',
      sid: map[Constant.fsSocietyId] ?? '',
      block: map[Constant.fsBlock] ?? '',
      houseNo: map[Constant.fsHouseNumber] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Member(id: $id, name: $name, email: $email, sid: $sid, block: $block, houseNo: $houseNo)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Member && other.id == id && other.name == name && other.email == email && other.sid == sid && other.block == block && other.houseNo == houseNo;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ sid.hashCode ^ block.hashCode ^ houseNo.hashCode;
  }
}

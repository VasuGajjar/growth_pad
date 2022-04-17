import 'dart:convert';

import '../../util/constants.dart';

class Secretary {
  final String id;
  final String name;
  final String email;
  final String sid;
  Secretary({
    required this.id,
    required this.name,
    required this.email,
    required this.sid,
  });

  Secretary copyWith({
    String? id,
    String? name,
    String? email,
    String? sid,
  }) {
    return Secretary(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      sid: sid ?? this.sid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.fsId: id,
      Constant.fsName: name,
      Constant.fsEmail: email,
      Constant.fsSocietyId: sid,
    };
  }

  factory Secretary.fromMap(Map<String, dynamic> map) {
    return Secretary(
      id: map[Constant.fsId] ?? '',
      name: map[Constant.fsName] ?? '',
      email: map[Constant.fsEmail] ?? '',
      sid: map[Constant.fsSocietyId] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Secretary.fromJson(String source) => Secretary.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Secretary(id: $id, name: $name, email: $email, sid: $sid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Secretary && other.id == id && other.name == name && other.email == email && other.sid == sid;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ email.hashCode ^ sid.hashCode;
  }
}

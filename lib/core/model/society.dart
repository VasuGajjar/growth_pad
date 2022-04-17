import 'dart:convert';

import '../../util/constants.dart';

class Society {
  final String id;
  final String name;
  final String address;
  final String totalHouses;
  final String searchName;
  Society({
    required this.id,
    required this.name,
    required this.address,
    required this.totalHouses,
    required this.searchName,
  });

  Society copyWith({
    String? id,
    String? name,
    String? address,
    String? totalHouses,
    String? searchName,
  }) {
    return Society(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      totalHouses: totalHouses ?? this.totalHouses,
      searchName: searchName ?? this.searchName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      Constant.fsId: id,
      Constant.fsName: name,
      Constant.fsAddress: address,
      Constant.fsTotalHouses: totalHouses,
      Constant.fsSearchName: searchName,
    };
  }

  factory Society.fromMap(Map<String, dynamic> map) {
    return Society(
      id: map[Constant.fsId] ?? '',
      name: map[Constant.fsName] ?? '',
      address: map[Constant.fsAddress] ?? '',
      totalHouses: map[Constant.fsTotalHouses] ?? '',
      searchName: map[Constant.fsSearchName] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Society.fromJson(String source) => Society.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Society(id: $id, name: $name, address: $address, totalHouses: $totalHouses, searchName: $searchName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Society && other.id == id && other.name == name && other.address == address && other.totalHouses == totalHouses && other.searchName == searchName;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ address.hashCode ^ totalHouses.hashCode ^ searchName.hashCode;
  }
}

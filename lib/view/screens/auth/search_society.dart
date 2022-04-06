import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/view/screens/auth/member_registration_screen.dart';

import '../../../controller/auth_controller.dart';
import '../../../data/model/society.dart';
import '../../base/scrollable_list.dart';
import '../../base/search_bar.dart';

class SearchSociety extends StatefulWidget {
  const SearchSociety({Key? key}) : super(key: key);

  @override
  State<SearchSociety> createState() => _SearchSocietyState();
}

class _SearchSocietyState extends State<SearchSociety> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: SearchToolbar(onSearch: (value) => setState(() => query = value))),
      body: FutureBuilder<List<Society>>(
        future: Get.find<AuthController>().searchSociety(query),
        builder: (_, snapshot) => ScrollableList<Society>(
          padding: const EdgeInsets.symmetric(vertical: 12),
          data: snapshot.data,
          builder: (_, i, item) => societyTile(item),
        ),
      ),
    );
  }

  Widget societyTile(Society society) {
    return InkWell(
      onTap: () => Get.to(() => MemberRegistrationScreen(societyId: society.id)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              society.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              society.address,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

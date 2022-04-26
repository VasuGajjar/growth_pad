import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/screens/auth/member_registration_screen.dart';

import '../../../core/controller/auth_controller.dart';
import '../../../core/model/society.dart';
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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: SearchToolbar(onSearch: (value) => setState(() => query = value)),
      ),
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
            Text(society.name, style: TextStyles.p1Bold),
            Text(society.address, style: TextStyles.p2Normal),
          ],
        ),
      ),
    );
  }
}

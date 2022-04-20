import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/notice_controller.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/notice.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/util/constants.dart';
import 'package:growthpad/view/base/scrollable_list.dart';
import 'package:growthpad/view/screens/notice/add_notice.dart';
import 'package:growthpad/view/screens/notice/notice_detail.dart';
import 'package:growthpad/view/screens/notice/view/notice_tile.dart';

class NoticeScreen extends StatefulWidget {
  const NoticeScreen({Key? key}) : super(key: key);

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  final bool isSecretary = (Get.find<UserType>() == UserType.secretary);
  late final String societyId = isSecretary ? Get.find<Secretary>().sid : Get.find<Member>().sid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notice Board')),
      body: StreamBuilder<List<Notice>>(
        stream: Get.find<NoticeController>().getNotices(societyId),
        builder: (context, snapshot) => ScrollableList<Notice>(
          padding: const EdgeInsets.all(8),
          data: snapshot.data?..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
          builder: (context, index, item) => NoticeTile(
            notice: item,
            onTap: () => Get.dialog(NoticeDetail(notice: item, isSecretary: isSecretary)),
          ),
        ),
      ),
      floatingActionButton: isSecretary
          ? FloatingActionButton.extended(
              onPressed: () => Get.to(() => const AddNotice()),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add New'),
            )
          : const SizedBox.shrink(),
    );
  }
}

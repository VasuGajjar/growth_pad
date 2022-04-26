import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/event_controller.dart';
import 'package:growthpad/core/model/event.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/util/constants.dart';
import 'package:growthpad/view/base/scrollable_list.dart';
import 'package:growthpad/view/screens/event/add_event.dart';
import 'package:growthpad/view/screens/event/joined_members.dart';
import 'package:growthpad/view/screens/event/view/event_tile.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final bool isSecretary = (Get.find<UserType>() == UserType.secretary);
  late final String societyId = isSecretary ? Get.find<Secretary>().sid : Get.find<Member>().sid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        title: const Text('Events'),
      ),
      body: StreamBuilder<List<Event>>(
        stream: Get.find<EventController>().getEvents(societyId),
        builder: (context, snapshot) => ScrollableList<Event>(
          padding: const EdgeInsets.all(8),
          data: snapshot.data?..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
          builder: (context, index, item) => EventTile(
            isSecretary: isSecretary,
            event: item,
            onSecretaryTap: () => Get.to(() => JoinedMembers(event: item)),
            onMemberTap: () {
              AppOverlay.showProgressBar();
              Get.find<EventController>().payAndJoin(
                event: item,
                user: Get.find<Member>(),
                onResult: (status, message) {
                  AppOverlay.closeProgressBar();
                  AppOverlay.showToast(message);
                  setState(() {});
                },
              );
            },
            // onTap: () => Get.dialog((notice: item, isSecretary: isSecretary)),
          ),
        ),
      ),
      floatingActionButton: isSecretary
          ? FloatingActionButton.extended(
              onPressed: () => Get.to(() => const AddEvent()),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add New'),
            )
          : const SizedBox.shrink(),
    );
  }
}

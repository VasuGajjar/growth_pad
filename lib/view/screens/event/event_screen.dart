import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/util/constants.dart';
import 'package:growthpad/view/screens/event/add_event.dart';

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
      appBar: AppBar(title: const Text('Events')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddEvent()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add New'),
      ),
    );
  }
}

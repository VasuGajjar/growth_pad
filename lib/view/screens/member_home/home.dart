import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/data/model/member.dart';
import 'package:growthpad/view/screens/chat/chat_screen.dart';

class MemberHome extends StatefulWidget {
  const MemberHome({Key? key}) : super(key: key);

  @override
  State<MemberHome> createState() => _MemberHomeState();
}

class _MemberHomeState extends State<MemberHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => Get.to(() => ChatScreen(societyId: Get.find<Member>().sid)),
        child: const Center(child: Text('Member Home Page')),
      ),
    );
  }
}

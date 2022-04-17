import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/chat_controller.dart';
import 'package:growthpad/core/model/chat_message.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/core/model/society.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/util/assets.dart';
import 'package:growthpad/util/constants.dart';
import 'package:growthpad/view/base/lottie_with_text.dart';
import 'package:growthpad/view/base/scrollable_list.dart';

class ChatScreen extends StatefulWidget {
  final String societyId;

  const ChatScreen({
    Key? key,
    required this.societyId,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String userId;
  late String userName;
  Society? society;

  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Society?>(
          future: ChatController.getSocietyDetails(widget.societyId),
          builder: (context, snapshot) {
            if (snapshot.hasError) return const Text('Error!');
            return Text(snapshot.data?.name ?? '-');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: ChatController.getChatMsg(widget.societyId),
              builder: (context, snapshot) => ScrollableList<ChatMessage>(
                data: snapshot.data,
                reverse: true,
                builder: (context, index, item) => chatMessageTile(item),
                emptyBuilder: (_) => const Center(child: LottieWithText(animation: Assets.emptyData, text: 'No Message till now.')),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 0, 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                          filled: true, fillColor: AppColors.backgroundColor, border: InputBorder.none, contentPadding: EdgeInsets.only(left: 24)),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send_rounded),
                onPressed: () {
                  if (messageController.text.trim().isEmpty) return;

                  ChatController.sendMsg(
                    widget.societyId,
                    ChatMessage(
                      senderId: userId,
                      senderName: userName,
                      message: messageController.text,
                      timestamp: DateConverter.timeToString(DateTime.now()),
                    ),
                  );

                  messageController.text = '';
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void getUserData() {
    if (Get.find<UserType>() == UserType.member) {
      userId = Get.find<Member>().id;
      userName = Get.find<Member>().name;
    } else if (Get.find<UserType>() == UserType.secretary) {
      userId = Get.find<Secretary>().id;
      userName = Get.find<Secretary>().name;
    }
  }

  Widget chatMessageTile(ChatMessage message) {
    bool isMe = message.senderId == userId;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.fromLTRB(12, 6, 12, 4),
        decoration: BoxDecoration(
          color: isMe ? AppColors.backgroundColor : AppColors.secondaryColor,
          borderRadius: BorderRadius.circular(12).copyWith(
            bottomLeft: isMe ? null : Radius.circular(0),
            bottomRight: isMe ? Radius.circular(0) : null,
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message.senderName,
              style: TextStyles.p3Bold.copyWith(color: isMe ? AppColors.secondaryColor : AppColors.backgroundColor),
            ),
            Text(
              message.message,
              style: TextStyles.p1Normal.copyWith(color: isMe ? Colors.black : Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

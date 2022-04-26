import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/event_controller.dart';
import 'package:growthpad/core/model/event.dart';
import 'package:growthpad/core/model/event_payment.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/progressbar.dart';
import 'package:growthpad/view/base/scrollable_list.dart';

class JoinedMembers extends StatelessWidget {
  final Event event;

  const JoinedMembers({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(event.title)),
      body: StreamBuilder<List<EventPayment>>(
        stream: Get.find<EventController>().getMembers(event.id),
        builder: (context, snapshot) => ScrollableList<EventPayment>(
          padding: const EdgeInsets.all(8),
          data: snapshot.data,
          builder: (context, index, item) => Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(12),
            elevation: 4,
            color: AppColors.cardColor,
            child: FutureBuilder<Member?>(
              future: Get.find<EventController>().getName(item.userId),
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return ListTile(
                    title: Text('Loading...', style: TextStyles.p1Normal),
                    subtitle: Text('Please Wait', style: TextStyles.p2Normal),
                    trailing: Transform.scale(child: const Progressbar(), scale: 0.6),
                  );
                }

                return ListTile(
                  title: Text(snap.data?.name ?? 'Error!', style: TextStyles.p1Normal),
                  subtitle: Text('${snap.data?.block ?? ''} ${snap.data?.houseNo ?? ''}', style: TextStyles.p2Normal),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

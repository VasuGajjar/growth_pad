import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/request_controller.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:growthpad/view/base/scrollable_list.dart';

class RequestList extends StatefulWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  State<RequestList> createState() => _RequestListState();
}

class _RequestListState extends State<RequestList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Requested Users')),
      body: GetBuilder<RequestController>(
        init: Get.find<RequestController>(),
        builder: (controller) {
          String societyId = Get.find<Secretary>().sid;

          return FutureBuilder<List<Member>>(
            future: controller.getRequestingMembers(societyId),
            builder: (context, snapshot) => ScrollableList<Member>(
              error: snapshot.hasError,
              data: snapshot.data,
              builder: (context, index, item) => ListTile(
                title: Text(item.name),
                subtitle: Text('${item.email}\n${item.block} ${item.houseNo}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FilledButton(
                      onClick: () async {
                        AppOverlay.showProgressBar();
                        await controller.acceptUser(item);
                        AppOverlay.closeProgressBar();
                      },
                      text: 'Accept',
                      backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                      textColor: AppColors.primaryColor,
                      shadowColor: Colors.transparent,
                      margin: const EdgeInsets.only(right: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    FilledButton(
                      text: 'Reject',
                      onClick: () async {
                        AppOverlay.showProgressBar();
                        await controller.rejectUser(item);
                        AppOverlay.closeProgressBar();
                      },
                      backgroundColor: AppColors.errorColor.withOpacity(0.3),
                      textColor: AppColors.errorColor,
                      shadowColor: Colors.transparent,
                      margin: const EdgeInsets.only(left: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

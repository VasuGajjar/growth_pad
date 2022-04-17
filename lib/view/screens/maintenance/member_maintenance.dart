import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/maintenance_controller.dart';
import 'package:growthpad/core/model/maintenance.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/view/base/scrollable_list.dart';
import 'package:growthpad/view/screens/maintenance/view/member_maintenance_tile.dart';

class MemberMaintenance extends StatefulWidget {
  const MemberMaintenance({Key? key}) : super(key: key);

  @override
  State<MemberMaintenance> createState() => _MemberMaintenanceState();
}

class _MemberMaintenanceState extends State<MemberMaintenance> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Maintenance')),
      body: StreamBuilder<List<Maintenance>>(
        stream: Get.find<MaintenanceController>().getMaintenanceList(Get.find<Member>().sid),
        builder: (context, snapshot) => ScrollableList<Maintenance>(
          data: snapshot.data?..sort((a, b) => a.deadLine.compareTo(b.deadLine)),
          error: snapshot.hasError,
          padding: const EdgeInsets.all(8),
          builder: (context, index, item) => MemberMaintenanceTile(
            maintenance: item,
            onPayTap: () {
              AppOverlay.showProgressBar();
              Get.find<MaintenanceController>().onMaintenancePay(
                maintenance: item,
                userId: Get.find<Member>().id,
                onResult: (status, message) {
                  AppOverlay.closeProgressBar();
                  AppOverlay.showToast(message);
                  setState(() {});
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

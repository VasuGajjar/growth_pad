import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/view/screens/maintenance/view/pending_tile.dart';

import '../../../core/controller/maintenance_controller.dart';
import '../../../core/model/maintenance.dart';
import '../../../core/model/secretary.dart';
import '../../../theme/colors.dart';
import '../../base/scrollable_list.dart';

class PendingMemberScreen extends StatefulWidget {
  final Maintenance maintenance;

  const PendingMemberScreen({Key? key, required this.maintenance}) : super(key: key);

  @override
  State<PendingMemberScreen> createState() => _PendingMemberScreenState();
}

class _PendingMemberScreenState extends State<PendingMemberScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: Text('${widget.maintenance.month} ${widget.maintenance.year}')),
      body: StreamBuilder<List<Member>>(
        stream: Get.find<MaintenanceController>().getSocietyUsers(Get.find<Secretary>().sid),
        builder: (context, snapshot) => ScrollableList<Member>(
          data: snapshot.data,
          error: snapshot.hasError,
          padding: const EdgeInsets.all(8),
          builder: (context, index, item) => PendingTile(member: item, maintenanceId: widget.maintenance.id),
        ),
      ),
    );
  }
}

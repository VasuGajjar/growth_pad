import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/maintenance_controller.dart';
import 'package:growthpad/core/model/maintenance.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/view/base/scrollable_list.dart';
import 'package:growthpad/view/screens/maintenance/add_maintenance.dart';
import 'package:growthpad/view/screens/maintenance/pending_member.dart';
import 'package:growthpad/view/screens/maintenance/view/maintenance_tile.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(title: const Text('Maintenance')),
      body: StreamBuilder<List<Maintenance>>(
        stream: Get.find<MaintenanceController>().getMaintenanceList(Get.find<Secretary>().sid),
        builder: (context, snapshot) => ScrollableList<Maintenance>(
          data: snapshot.data?..sort((a, b) => a.deadLine.compareTo(b.deadLine)),
          error: snapshot.hasError,
          padding: const EdgeInsets.all(8),
          builder: (context, index, item) => MaintenanceTile(
            maintenance: item,
            onTap: () => Get.to(() => PendingMemberScreen(maintenance: item)),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddMaintenance()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add New'),
      ),
    );
  }
}

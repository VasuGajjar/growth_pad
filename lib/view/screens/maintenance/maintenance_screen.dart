import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/view/screens/maintenance/add_maintenance.dart';
import 'package:growthpad/view/screens/maintenance/view/maintenance_list.dart';

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
      body: const MaintenanceList(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.to(() => const AddMaintenance()),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add new one'),
      ),
    );
  }
}

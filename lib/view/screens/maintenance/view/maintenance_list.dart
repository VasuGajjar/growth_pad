import 'package:flutter/material.dart';
import 'package:growthpad/view/base/scrollable_list.dart';

class MaintenanceList extends StatelessWidget {
  const MaintenanceList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScrollableList<Widget>(
      data: const [],
      builder: (context, index, item) => item,
    );
  }
}

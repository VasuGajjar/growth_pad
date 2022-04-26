import 'package:flutter/material.dart';
import 'package:growthpad/core/model/maintenance.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';

class MaintenanceTile extends StatelessWidget {
  final Maintenance maintenance;
  final void Function() onTap;

  const MaintenanceTile({
    Key? key,
    required this.maintenance,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      elevation: 4,
      color: AppColors.cardColor,
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('${maintenance.month} ${maintenance.year}', style: TextStyles.p1Normal),
        subtitle: Text('Penalty [Rs.${maintenance.penalty}] - ' + DateConverter.timeToString(maintenance.deadLine, output: 'dd MMM yyyy'), style: TextStyles.p2Normal),
        trailing: Text(
          'Rs. ${maintenance.amount}',
          style: TextStyles.p1Bold.copyWith(color: AppColors.primaryColor),
        ),
      ),
    );
  }
}

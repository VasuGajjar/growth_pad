import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/maintenance_controller.dart';
import 'package:growthpad/core/model/maintenance.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/payment.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:growthpad/view/base/progressbar.dart';

class MemberMaintenanceTile extends StatelessWidget {
  final Maintenance maintenance;
  final void Function() onPayTap;
  final void Function(Payment payment) onDownloadTap;
  bool isPenalty = false;

  MemberMaintenanceTile({
    Key? key,
    required this.maintenance,
    required this.onPayTap,
    required this.onDownloadTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    isPenalty = DateTime.now().isAfter(maintenance.deadLine);

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      elevation: 4,
      color: AppColors.cardColor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text('${maintenance.month} ${maintenance.year}'),
        children: [
          titleText(title: 'Penalty:', text: 'Rs. ${maintenance.penalty}'),
          titleText(title: 'Penalty Date:', text: DateConverter.timeToString(maintenance.deadLine, output: 'dd MMM yyyy')),
          FutureBuilder<Payment?>(
              future: Get.find<MaintenanceController>().findPaymentDetails(maintenanceId: maintenance.id, userId: Get.find<Member>().id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Align(alignment: Alignment.topCenter, child: Progressbar());
                }

                if (snapshot.data != null) {
                  return paidPrice(snapshot.data!);
                } else {
                  return priceAndButton();
                }
              }),
        ],
      ),
    );
  }

  Widget titleText({required String title, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Text(title, style: TextStyles.p2Normal),
          const Spacer(),
          Text(text, style: TextStyles.p2Bold.copyWith(color: AppColors.primaryColor)),
        ],
      ),
    );
  }

  Widget priceAndButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Row(
        children: [
          Text('Rs. ${maintenance.amount}', style: TextStyles.p1Bold.copyWith(color: AppColors.primaryColor)),
          const Spacer(),
          FilledButton(
            text: 'Pay',
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            textColor: AppColors.primaryColor,
            backgroundColor: AppColors.primaryColor.withOpacity(0.3),
            shadowColor: Colors.transparent,
            onClick: onPayTap,
          ),
        ],
      ),
    );
  }

  Widget paidPrice(Payment payment) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Row(
        children: [
          Text('Rs. ${payment.amount}', style: TextStyles.p1Bold.copyWith(color: AppColors.primaryColor)),
          if (payment.penalty) Text(' (Late Payment)', style: TextStyles.p2Normal.copyWith(color: AppColors.primaryColor)),
          const Spacer(),
          FilledButton(
            text: 'Download Pdf',
            margin: EdgeInsets.zero,
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
            textColor: AppColors.infoColor,
            backgroundColor: AppColors.infoColor.withOpacity(0.3),
            shadowColor: Colors.transparent,
            onClick: () => onDownloadTap(payment),
          ),
        ],
      ),
    );
  }
}

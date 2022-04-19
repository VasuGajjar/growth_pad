import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/maintenance_controller.dart';
import 'package:growthpad/core/model/payment.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/progressbar.dart';

import '../../../../core/model/member.dart';
import '../../../../theme/colors.dart';

class PendingTile extends StatelessWidget {
  final Member member;
  final String maintenanceId;

  const PendingTile({Key? key, required this.member, required this.maintenanceId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8),
      elevation: 4,
      color: AppColors.cardColor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(member.name),
        subtitle: Text('${member.block} ${member.houseNo}'),
        children: [
          FutureBuilder<Payment?>(
              future: Get.find<MaintenanceController>().findPaymentDetails(maintenanceId: maintenanceId, userId: member.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Align(alignment: Alignment.topCenter, child: Progressbar());
                }

                if (snapshot.data != null) {
                  return paid(snapshot.data!);
                } else {
                  return notPaid();
                }
              }),
        ],
      ),
    );
  }

  Widget paid(Payment payment) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Maintenance Paid',
            style: TextStyles.p2Bold.copyWith(color: AppColors.primaryColor),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text(
                'Payment Date :',
                style: TextStyles.p3Normal,
              ),
              const Spacer(),
              Text(
                DateConverter.timeToString(payment.paymentTime, output: 'dd MMM yyyy hh:mm a'),
                style: TextStyles.p3Bold,
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Text(
                'Late Penalty :',
                style: TextStyles.p3Normal,
              ),
              const Spacer(),
              Text(
                payment.penalty ? 'Yes' : 'No',
                style: TextStyles.p3Bold,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget notPaid() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          'Maintenance not Paid',
          style: TextStyles.p2Bold.copyWith(color: AppColors.warningColor),
        ),
      ),
    );
  }
}

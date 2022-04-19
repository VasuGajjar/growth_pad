import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/maintenance_controller.dart';
import 'package:growthpad/core/model/maintenance.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/core/service/notification_service.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/edit_text.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:growthpad/view/base/resizable_scrollview.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:uuid/uuid.dart';

import '../../../helper/overlay.dart';

class AddMaintenance extends StatefulWidget {
  const AddMaintenance({Key? key}) : super(key: key);

  @override
  State<AddMaintenance> createState() => _AddMaintenanceState();
}

class _AddMaintenanceState extends State<AddMaintenance> {
  late DateTime selectedDate;
  double amount = 0;
  late DateTime penaltyDate;
  double penalty = 0;

  GlobalKey<FormState> amountKey = GlobalKey<FormState>();
  GlobalKey<FormState> penaltyKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    penaltyDate = DateTime(selectedDate.year, selectedDate.month, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Maintenance')),
      body: ResizableScrollView(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: ListTile(
              onTap: () {},
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                child: const Icon(CupertinoIcons.calendar, color: AppColors.primaryColor),
              ),
              title: const Text('Select Month & Year: ', style: TextStyles.p2Normal),
              subtitle: Text(DateConverter.timeToString(selectedDate, output: 'MMMM yyyy'), style: TextStyles.p1Bold),
              trailing: FilledButton(
                text: 'Change',
                onClick: onDateChangeTap,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.fromLTRB(6, 6, 0, 6),
                backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                textColor: AppColors.primaryColor,
                shadowColor: Colors.transparent,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                    child: const Icon(CupertinoIcons.money_dollar, color: AppColors.primaryColor),
                  ),
                ),
                Expanded(
                  child: EditText(
                    formKey: amountKey,
                    label: 'Amount (INR)',
                    errorText: 'Enter Amount',
                    inputType: TextInputType.number,
                    onChange: (value) => amount = double.tryParse(value ?? '') ?? 0,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: ListTile(
              onTap: () {},
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                child: const Icon(CupertinoIcons.calendar_badge_plus, color: AppColors.primaryColor),
              ),
              title: const Text('Select Penalty Date: ', style: TextStyles.p2Normal),
              subtitle: Text(DateConverter.timeToString(penaltyDate, output: 'dd MMM yyyy'), style: TextStyles.p1Bold),
              trailing: FilledButton(
                text: 'Change',
                onClick: onPenaltyDateChangeTap,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.fromLTRB(6, 6, 0, 6),
                backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                textColor: AppColors.primaryColor,
                shadowColor: Colors.transparent,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                    child: const Icon(CupertinoIcons.number, color: AppColors.primaryColor),
                  ),
                ),
                Expanded(
                  child: EditText(
                    formKey: penaltyKey,
                    label: 'Penalty (Optional)',
                    errorText: 'Enter Amount',
                    inputType: TextInputType.number,
                    onChange: (value) => penalty = double.tryParse(value ?? '') ?? 0,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          FilledButton(
            text: 'Save',
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            onClick: () {
              Get.focusScope?.unfocus();
              if (validate()) {
                Maintenance maintenance = Maintenance(
                  id: const Uuid().v1(),
                  sid: Get.find<Secretary>().sid,
                  month: DateConverter.timeToString(selectedDate, output: 'MMMM'),
                  year: DateConverter.timeToString(selectedDate, output: 'yyyy'),
                  amount: amount,
                  penalty: penalty,
                  deadLine: penaltyDate,
                  createDate: DateTime.now(),
                );

                AppOverlay.showProgressBar();
                Get.find<MaintenanceController>().addMaintenance(
                  maintenance: maintenance,
                  onResult: (status, message) {
                    AppOverlay.closeProgressBar();
                    AppOverlay.showToast(message);
                    if (status) {
                      NotificationService.sendNotification(topic: Get.find<Secretary>().sid, title: 'GrowthPad', body: 'New Maintenance Added');
                      Get.back();
                    }
                  },
                );
              }
            },
          )
        ],
      ),
    );
  }

  Future<void> onDateChangeTap() async {
    var today = DateTime.now();
    selectedDate = await showMonthPicker(context: context, initialDate: today, firstDate: today, lastDate: today.add(365.days)) ?? selectedDate;
    setState(() {});
  }

  Future<void> onPenaltyDateChangeTap() async {
    var temp = DateTime(selectedDate.year, selectedDate.month);

    penaltyDate = await showDatePicker(
          context: context,
          initialDate: temp.add(15.days),
          firstDate: temp.add(4.days),
          lastDate: selectedDate.add(28.days),
        ) ??
        penaltyDate;
    setState(() {});
  }

  bool validate() {
    if (!(amountKey.currentState?.validate() ?? false)) {
      return false;
    }

    if (amount == 0) {
      AppOverlay.showToast('Enter Valid Amount');
      return false;
    }

    if (penaltyDate.isBefore(DateTime.now())) {
      AppOverlay.showToast('Select Valid Penalty Date');
      return false;
    }

    return true;
  }
}

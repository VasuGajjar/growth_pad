import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/event_controller.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/edit_text.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:growthpad/view/base/resizable_scrollview.dart';

class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  State<AddEvent> createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  TextEditingController titleController = TextEditingController(),
      descriptionController = TextEditingController(),
      amountController = TextEditingController();
  bool isPaid = false;
  DateTime eventDate = DateTime.now();
  TimeOfDay eventTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Event')),
      body: ResizableScrollView(
        padding: const EdgeInsets.all(8),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: TextField(
              controller: titleController,
              style: TextStyles.h2Bold,
              autofocus: true,
              maxLines: 1,
              decoration: const InputDecoration(hintText: 'Title Here...', border: InputBorder.none),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
            child: TextField(
              controller: descriptionController,
              style: TextStyles.p1Normal,
              minLines: 1,
              maxLines: 5,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              decoration: const InputDecoration(hintText: '(Optional) Description Here...', border: InputBorder.none),
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
              title: Text('Select Date: ', style: TextStyles.p2Normal),
              subtitle: Text(DateConverter.timeToString(eventDate, output: 'dd MMM yyyy'), style: TextStyles.p1Bold),
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
            padding: const EdgeInsets.only(top: 24),
            child: ListTile(
              onTap: () {},
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryColor.withOpacity(0.2),
                child: const Icon(CupertinoIcons.time, color: AppColors.primaryColor),
              ),
              title: Text('Select Time: ', style: TextStyles.p2Normal),
              // subtitle: Text(DateConverter.timeToString(eventTime, output: 'hh:mm a'), style: TextStyles.p1Bold),
              subtitle: Text(eventTime.format(context), style: TextStyles.p1Bold),
              trailing: FilledButton(
                text: 'Change',
                onClick: onTimeChangeTap,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.fromLTRB(6, 6, 0, 6),
                backgroundColor: AppColors.primaryColor.withOpacity(0.3),
                textColor: AppColors.primaryColor,
                shadowColor: Colors.transparent,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 4),
            child: Row(
              children: [
                Text('Paid Event :', style: TextStyles.p2Normal),
                const Spacer(),
                CupertinoSwitch(
                  value: isPaid,
                  onChanged: (value) => setState(() => isPaid = value),
                  activeColor: Colors.green,
                ),
              ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: isPaid ? 20 + 40 + 26 : 0,
            child: AnimatedScale(
              duration: const Duration(milliseconds: 200),
              scale: isPaid ? 1 : 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                // child: TextField(
                //   controller: amountController,
                //   style: TextStyles.p1Normal,
                //   keyboardType: TextInputType.number,
                //   decoration: const InputDecoration(hintText: 'Enter Amount', border: InputBorder.none),
                // ),
                child: EditText(
                  label: 'Amount',
                  onChange: (value) {},
                  textController: amountController,
                  errorText: isPaid ? 'Enter Price' : null,
                  inputType: TextInputType.number,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (titleController.text.trim().isEmpty) {
            AppOverlay.showToast('Enter title');
            return;
          }

          DateTime eventDateTime = DateTime(eventDate.year, eventDate.month, eventDate.day, eventTime.hour, eventTime.minute);
          if (eventDateTime.isBefore(DateTime.now())) {
            AppOverlay.showToast('Select future date & time');
            return;
          }

          var amount = double.tryParse(amountController.text) ?? 0;
          if (isPaid && amount <= 0) {
            AppOverlay.showToast('Enter valid amount');
            return;
          }

          AppOverlay.showProgressBar();
          var status = await Get.find<EventController>().addEvent(
            title: titleController.text.trim(),
            description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
            isPaid: isPaid,
            amount: amount,
            eventTime: eventDateTime,
          );
          AppOverlay.closeProgressBar();
          AppOverlay.showToast(status ? 'Saved' : 'Failure');
          if (status) Get.back();
        },
        icon: const Icon(Icons.upload_rounded),
        label: const Text('Save'),
      ),
    );
  }

  Future<void> onDateChangeTap() async {
    eventDate = await showDatePicker(
          context: context,
          initialDate: eventDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(90.days),
        ) ??
        eventDate;
    setState(() {});
  }

  Future<void> onTimeChangeTap() async {
    eventTime = await showTimePicker(context: context, initialTime: eventTime) ?? eventTime;
    setState(() {});
  }
}

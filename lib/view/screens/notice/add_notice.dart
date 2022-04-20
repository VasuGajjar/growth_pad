import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/notice_controller.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/resizable_scrollview.dart';

class AddNotice extends StatefulWidget {
  const AddNotice({Key? key}) : super(key: key);

  @override
  State<AddNotice> createState() => _AddNoticeState();
}

class _AddNoticeState extends State<AddNotice> {
  TextEditingController titleController = TextEditingController(), descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Notice')),
      body: ResizableScrollView(
        padding: const EdgeInsets.all(8),
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(12).copyWith(bottom: 0),
            child: TextField(
              controller: titleController,
              style: TextStyles.h2Bold,
              autofocus: true,
              maxLines: 1,
              decoration: const InputDecoration(hintText: 'Title Here...', border: InputBorder.none),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12).copyWith(top: 0),
            child: TextField(
              controller: descriptionController,
              style: TextStyles.p1Normal,
              maxLines: null,
              scrollPhysics: const NeverScrollableScrollPhysics(),
              decoration: const InputDecoration(hintText: 'Description Here...', border: InputBorder.none),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (titleController.text.trim().isEmpty) {
            AppOverlay.showToast('Enter title');
            return;
          }

          if (descriptionController.text.trim().isEmpty) {
            AppOverlay.showToast('Enter description');
            return;
          }

          AppOverlay.showProgressBar();
          var status = await Get.find<NoticeController>().addNotice(titleController.text.trim(), descriptionController.text.trim());
          AppOverlay.closeProgressBar();
          AppOverlay.showToast(status ? 'Saved' : 'Failure');
          if (status) Get.back();
        },
        icon: const Icon(Icons.upload_rounded),
        label: const Text('Save'),
      ),
    );
  }
}

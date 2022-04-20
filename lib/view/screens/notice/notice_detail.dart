import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/notice_controller.dart';
import 'package:growthpad/core/model/notice.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/resizable_scrollview.dart';

class NoticeDetail extends StatelessWidget {
  final Notice notice;
  final bool isSecretary;

  const NoticeDetail({Key? key, required this.notice, required this.isSecretary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: Get.width * 0.9,
            height: Get.height * 0.5,
            child: Hero(
              tag: 'notice_${notice.id}',
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                color: AppColors.cardColor,
                child: ResizableScrollView(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  padding: const EdgeInsets.all(12),
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      notice.title,
                      style: TextStyles.h2Bold,
                    ),
                    Text(
                      DateConverter.timeToString(notice.createdAt, output: 'd MMM yyyy, hh:mm a'),
                      style: TextStyles.p3Normal,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notice.description,
                      style: TextStyles.p2Normal,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
          if (isSecretary)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: FloatingActionButton.extended(
                onPressed: () async {
                  AppOverlay.showProgressBar();
                  var status = await Get.find<NoticeController>().deleteNotice(notice.docReference);
                  AppOverlay.closeProgressBar();

                  if(status) Get.back();
                },
                elevation: 0,
                backgroundColor: AppColors.errorColor,
                icon: const Icon(Icons.delete_rounded),
                label: const Text('Delete'),
              ),
            ),
        ],
      ),
    );
  }
}

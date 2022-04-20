import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/model/notice.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/core/service/notification_service.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/util/constants.dart';
import 'package:uuid/uuid.dart';

class NoticeController extends GetxController implements GetxService {
  final FirebaseFirestore firestore;

  NoticeController({required this.firestore});

  Future<bool> addNotice(String title, String description) async {
    try {
      Notice notice = Notice(
        id: const Uuid().v1(),
        sid: Get.find<Secretary>().sid,
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      await firestore.collection(Constant.cNotice).add(notice.toMap());
      NotificationService.sendNotification(topic: notice.sid, title: 'New Notice', body: title);
      return true;
    } catch (e) {
      Log.console('NoticeController.addNotice.error: $e');
      return false;
    }
  }

  Future<bool> deleteNotice(String noticeId) async {
    try {
      await firestore.collection(Constant.cNotice).doc(noticeId).delete();
      return true;
    } catch (e) {
      Log.console('NoticeController.addNotice.error: $e');
      return false;
    }
  }

  Stream<List<Notice>> getNotices(String societyId) {
    return firestore
        .collection(Constant.cNotice)
        .where(Constant.fsSocietyId, isEqualTo: societyId)
        .snapshots()
        .map((event) => event.docs.map((item) => Notice.fromMap(item.id, item.data())).toList());
  }
}

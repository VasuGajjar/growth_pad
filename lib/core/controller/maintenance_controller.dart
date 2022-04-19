import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/model/maintenance.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/payment.dart';
import 'package:growthpad/core/model/society.dart';
import 'package:growthpad/core/service/razorpay_service.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/util/constants.dart';
import 'package:uuid/uuid.dart';

class MaintenanceController extends GetxController implements GetxService {
  FirebaseFirestore firestore;

  MaintenanceController({required this.firestore});

  Future<void> addMaintenance({
    required Maintenance maintenance,
    required void Function(bool status, String message) onResult,
  }) async {
    try {
      var query = await firestore
          .collection(Constant.cMaintenance)
          .where(Constant.fsSocietyId, isEqualTo: maintenance.sid)
          .where(Constant.fsMonth, isEqualTo: maintenance.month)
          .where(Constant.fsYear, isEqualTo: maintenance.year)
          .get();

      if (query.docs.isEmpty) {
        await firestore.collection(Constant.cMaintenance).add(maintenance.toMap());
        onResult(true, 'Saved Successfully');
      } else {
        onResult(false, 'Maintenance for this month already exist');
      }
    } catch (e) {
      Log.console('MaintenanceController.addMaintenance.error: $e');
      onResult(false, 'Something went wrong');
    }
  }

  Stream<List<Maintenance>> getMaintenanceList(String societyId) {
    return firestore
        .collection(Constant.cMaintenance)
        .where(Constant.fsSocietyId, isEqualTo: societyId)
        // .orderBy(Constant.fsDeadLine)
        .snapshots()
        .map((event) => event.docs.map((item) => Maintenance.fromMap(item.data())).toList());
  }

  Stream<List<Member>> getSocietyUsers(String societyId) {
    return firestore
        .collection(Constant.cMember)
        .where(Constant.fsSocietyId, isEqualTo: societyId)
        .snapshots()
        .map((event) => event.docs.map((item) => Member.fromMap(item.data())).toList());
  }

  Future<void> onMaintenancePay({
    required Maintenance maintenance,
    required String userId,
    required void Function(bool status, String message, Payment? payment) onResult,
  }) async {
    try {
      bool isLate = DateTime.now().isAfter(maintenance.deadLine);
      double amount = maintenance.amount;
      if (isLate) amount += maintenance.penalty;

      await RazorpayService.present(
        amount: amount,
        name: Get.find<Member>().name,
        description: 'Maintenance Payment',
        onPaymentSuccess: (response) async {
          Payment payment = Payment(
            id: response.orderId ?? response.paymentId ?? response.signature ?? const Uuid().v1(),
            userId: userId,
            maintenanceId: maintenance.id,
            amount: amount,
            penalty: isLate,
            paymentTime: DateTime.now(),
          );

          await firestore.collection(Constant.cPayment).add(payment.toMap());
          onResult(true, 'Payment Successful', payment);
        },
        onPaymentError: (response) {
          onResult(false, response.message ?? 'Payment Error', null);
        },
        onExternalWallet: (response) {},
      );
    } catch (e) {
      Log.console('MaintenanceController.onMaintenancePay.error: $e');
      onResult(false, 'Something went wrong', null);
    }
  }

  Future<Payment?> findPaymentDetails({required String maintenanceId, required String userId}) async {
    var query = await firestore
        .collection(Constant.cPayment)
        .where(Constant.fsMaintenanceId, isEqualTo: maintenanceId)
        .where(Constant.fsUserId, isEqualTo: userId)
        .get();

    if (query.docs.isNotEmpty) {
      return Payment.fromMap(query.docs.first.data());
    } else {
      return null;
    }
  }

  Future<Society?> findSociety({required String societyId}) async {
    var query = await firestore.collection(Constant.cSociety).where(Constant.fsId, isEqualTo: societyId).get();

    if (query.docs.isNotEmpty) {
      return Society.fromMap(query.docs.first.data());
    } else {
      return null;
    }
  }
}

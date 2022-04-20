import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/model/event.dart';
import 'package:growthpad/core/model/event_payment.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/core/service/notification_service.dart';
import 'package:growthpad/core/service/razorpay_service.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/util/constants.dart';
import 'package:uuid/uuid.dart';

class EventController extends GetxController implements GetxService {
  final FirebaseFirestore firestore;

  EventController({required this.firestore});

  Future<bool> addEvent({
    required String title,
    String? description,
    required DateTime eventTime,
    required bool isPaid,
    required double amount,
  }) async {
    try {
      Event event = Event(
        id: const Uuid().v1(),
        sid: Get.find<Secretary>().sid,
        title: title,
        description: description,
        isPaid: isPaid,
        amount: amount,
        eventTime: eventTime,
        createdAt: DateTime.now(),
      );

      await firestore.collection(Constant.cEvent).add(event.toMap());
      NotificationService.sendNotification(topic: event.sid, title: 'New Event', body: event.title);
      return true;
    } catch (e) {
      Log.console('EventController.addEvent.error: $e');
      return false;
    }
  }

  Stream<List<Event>> getEvents(String societyId) {
    return firestore
        .collection(Constant.cEvent)
        .where(Constant.fsSocietyId, isEqualTo: societyId)
        .snapshots()
        .map((event) => event.docs.map((item) => Event.fromMap(item.data())).toList());
  }

  Stream<List<EventPayment>> getMembers(String eventId) {
    return firestore
        .collection(Constant.cEventPayment)
        .where(Constant.fsEventId, isEqualTo: eventId)
        .snapshots()
        .map((event) => event.docs.map((item) => EventPayment.fromMap(item.data())).toList());
  }

  Future<EventPayment?> getPayment(String eventId, String userId) async {
    try {
      var query = await firestore
          .collection(Constant.cEventPayment)
          .where(Constant.fsEventId, isEqualTo: eventId)
          .where(Constant.fsUserId, isEqualTo: userId)
          .get();

      if (query.docs.isNotEmpty) {
        return EventPayment.fromMap(query.docs.first.data());
      } else {
        return null;
      }
    } catch (e) {
      Log.console('EventController.getPayment.error: $e');
      return null;
    }
  }

  Future<Member?> getName(String userId) async {
    try {
      var query = await firestore.collection(Constant.cMember).where(Constant.fsId, isEqualTo: userId).get();

      if (query.docs.isNotEmpty) {
        return Member.fromMap(query.docs.first.data());
      } else {
        return null;
      }
    } catch (e) {
      Log.console('EventController.getName.error: $e');
      return null;
    }
  }

  Future<void> payAndJoin({
    required Event event,
    required Member user,
    required void Function(bool status, String message) onResult,
  }) async {
    try {
      if (event.isPaid) {
        await RazorpayService.present(
          amount: event.amount,
          name: user.name,
          description: event.title,
          onPaymentSuccess: (response) async {
            var status = await _joinEvent(
              paymentId: response.orderId ?? response.paymentId ?? response.signature ?? const Uuid().v1(),
              userId: user.id,
              event: event,
            );
            onResult(status, status ? 'Success' : 'Failed');
          },
          onPaymentError: (response) {
            onResult(false, response.message ?? 'Payment Error');
          },
          onExternalWallet: (response) {},
        );
      } else {
        var status = await _joinEvent(paymentId: const Uuid().v1(), userId: user.id, event: event);
        onResult(status, status ? 'Success' : 'Failed');
      }
    } catch (e) {
      Log.console('EventController.payAndJoin.error: $e');
    }
  }

  Future<bool> _joinEvent({
    required String paymentId,
    required String userId,
    required Event event,
  }) async {
    try {
      EventPayment payment = EventPayment(
        id: paymentId,
        userId: userId,
        eventId: event.id,
        amount: event.isPaid ? event.amount : null,
        paymentTime: DateTime.now(),
      );

      await firestore.collection(Constant.cEventPayment).add(payment.toMap());
      NotificationService.scheduleNotification(title: event.title, body: 'Get Ready, Time for Event', date: event.eventTime);
      return true;
    } catch (e) {
      Log.console('EventController._joinEvent.error: $e');
      return false;
    }
  }
}

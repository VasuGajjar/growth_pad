import 'package:get/get.dart';
import 'package:growthpad/core/service/notification_service.dart';

import '../model/member.dart';
import '../repository/request_repo.dart';

class RequestController extends GetxController implements GetxService {
  final RequestRepository requestRepository;

  RequestController({required this.requestRepository});

  Future<List<Member>> getRequestingMembers(String societyId) => requestRepository.getRequestingMembers(societyId);

  Future<void> acceptUser(Member member) async {
    await requestRepository.acceptUser(member);
    NotificationService.sendNotification(topic: member.id, title: 'GrowthPad', body: 'Your Request is Approved');
    update();
  }

  Future<void> rejectUser(Member member) async {
    await requestRepository.rejectUser(member);
    NotificationService.sendNotification(topic: member.id, title: 'GrowthPad', body: 'Your Request is Rejected');
    update();
  }
}

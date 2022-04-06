import 'package:get/get.dart';
import 'package:growthpad/data/model/member.dart';
import 'package:growthpad/data/repository/request_repo.dart';

class RequestController extends GetxController implements GetxService {
  final RequestRepository requestRepository;

  RequestController({required this.requestRepository});

  Future<List<Member>> getRequestingMembers(String societyId) => requestRepository.getRequestingMembers(societyId);

  Future<void> acceptUser(Member member) async {
    await requestRepository.acceptUser(member);
    update();
  }

  Future<void> rejectUser(Member member) async {
    await requestRepository.rejectUser(member);
    update();
  }
}

import 'package:get/get.dart';
import 'package:growthpad/core/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/log.dart';
import '../../util/constants.dart';
import '../model/member.dart';
import '../model/secretary.dart';
import '../model/society.dart';
import '../repository/auth_repo.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepository authRepository;

  AuthController({required this.authRepository});

  Future<void> login({
    required String email,
    required String password,
    required UserType type,
    required void Function(Member user, bool isVerified) onMemberLogin,
    required void Function(Secretary user) onSecretaryLogin,
    required void Function(String message) onFailure,
  }) async {
    try {
      if (type == UserType.member) {
        await authRepository.memberLogin(email: email, password: password, onSuccess: onMemberLogin, onFailure: onFailure);
      } else {
        await authRepository.secretaryLogin(email: email, password: password, onSuccess: onSecretaryLogin, onFailure: onFailure);
      }
    } catch (e) {
      Log.console('AuthController.login.error: $e');
      onFailure('Something went wrong');
    }
  }

  Future<void> secretaryRegister({
    required String email,
    required String password,
    required String name,
    required String socName,
    required String address,
    required String houseNo,
    required String account,
    required String ifsc,
    required void Function(Secretary user, Society society) onSuccess,
    required void Function(String message) onFailure,
  }) async {
    try {
      await authRepository.secretaryRegistration(
        email: email,
        password: password,
        name: name,
        societyName: socName,
        address: address,
        totalHouses: houseNo,
        account: account,
        ifsc: ifsc,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
    } catch (e) {
      Log.console('AuthController.secretaryRegister.error: $e');
      onFailure('Something went wrong');
    }
  }

  Future<void> memberRegister({
    required String email,
    required String password,
    required String name,
    required String societyId,
    required String block,
    required String houseNo,
    required void Function(Member user, String secretaryId) onSuccess,
    required void Function(String message) onFailure,
  }) async {
    try {
      await authRepository.memberRegisteration(
        email: email,
        password: password,
        name: name,
        societyId: societyId,
        block: block,
        houseNo: houseNo,
        onSuccess: onSuccess,
        onFailure: onFailure,
      );
    } catch (e) {
      Log.console('AuthController.secretaryRegister.error: $e');
      onFailure('Something went wrong');
    }
  }

  Future<List<Society>> searchSociety(String query) => authRepository.fetchSocieties(query.toLowerCase());

  Future<Member?> searchMember(String uuid) async {
    return authRepository.searchMember(uuid);
  }

  Future<void> logout(UserType type) async {
    try {
      NotificationService.unsubscribe();
      await Get.find<SharedPreferences>().remove(Constant.spType);
      await Get.find<SharedPreferences>().remove(Constant.spUser);
      await Get.delete<UserType>(force: true);
      if (type == UserType.member || type == UserType.temp) await Get.delete<Member>(force: true);
      if (type == UserType.secretary) await Get.delete<Secretary>(force: true);
    } catch (e) {
      Log.console('AuthController.logout.error: $e');
    }
  }
}

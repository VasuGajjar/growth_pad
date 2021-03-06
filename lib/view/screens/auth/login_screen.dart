import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/service/notification_service.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/view/screens/auth/search_society.dart';
import 'package:growthpad/view/screens/requestes/requested_login.dart';
import 'package:growthpad/view/screens/secretary_home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/controller/auth_controller.dart';
import '../../../theme/colors.dart';
import '../../../util/assets.dart';
import '../../../util/constants.dart';
import '../../base/edit_text.dart';
import '../../base/filled_button.dart';
import '../member_home/home.dart';
import 'secretary_registration_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserType userType;

  const LoginScreen({Key? key, required this.userType}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> emailKey = GlobalKey();
  GlobalKey<FormState> passwordKey = GlobalKey();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      init: Get.find<AuthController>(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.cardColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              color: AppColors.onSecondaryColor,
              onPressed: Get.back,
            ),
            title: Row(
              children: [
                Image.asset(Assets.growthpadLogo, width: 35, height: 35),
                const SizedBox(width: 8),
                const Text("Growth", style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w900)),
                Text("Pad", style: TextStyle(color: AppColors.onSecondaryColor, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EditText(
                  formKey: emailKey,
                  label: 'Email',
                  inputType: TextInputType.emailAddress,
                  onChange: (value) => email = value ?? '',
                  errorText: 'Enter email',
                  validateEmail: true,
                ),
                EditText(
                  formKey: passwordKey,
                  label: 'Password',
                  obscureText: true,
                  inputType: TextInputType.visiblePassword,
                  onChange: (value) => password = value ?? '',
                  errorText: 'Enter password',
                  validatePassword: true,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  text: 'Login',
                  onClick: onLoginTap,
                ),
                FilledButton(
                  text: 'Create New Account',
                  backgroundColor: AppColors.cardColor,
                  textColor: AppColors.primaryColor,
                  onClick: () {
                    if (widget.userType == UserType.secretary) {
                      Get.to(() => const SecretaryRegistrationScreen());
                    } else if (widget.userType == UserType.member) {
                      Get.to(() => const SearchSociety());
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool validate() {
    bool email = emailKey.currentState?.validate() ?? false;
    bool password = passwordKey.currentState?.validate() ?? false;

    return (email && password);
  }

  onLoginTap() async {
    if (validate()) {
      AppOverlay.showProgressBar();
      Get.find<AuthController>()
          .login(
            email: email,
            password: password,
            type: widget.userType,
            onMemberLogin: (user, isVerified) {
              Log.console('Member: $user');
              NotificationService.subscribe(user.id, user.sid);
              if (isVerified) {
                Get.find<SharedPreferences>().setString(Constant.spType, UserType.member.toString());
              } else {
                Get.find<SharedPreferences>().setString(Constant.spType, UserType.temp.toString());
              }
              Get.find<SharedPreferences>().setString(Constant.spUser, user.toJson());

              if (isVerified) {
                Get.put(UserType.member, permanent: true);
                Get.put(user, permanent: true);
                Get.offAll(() => const MemberHome());
              } else {
                Get.put(UserType.temp, permanent: true);
                Get.put(user, permanent: true);
                Get.offAll(() => const RequestedLogin());
              }
            },
            onSecretaryLogin: (user) {
              Log.console('Secretary: $user');
              NotificationService.subscribe(user.id, user.sid);
              Get.find<SharedPreferences>().setString(Constant.spType, UserType.secretary.toString());
              Get.find<SharedPreferences>().setString(Constant.spUser, user.toJson());
              Get.put(UserType.secretary, permanent: true);
              Get.put(user, permanent: true);
              Get.offAll(() => const SecretaryHome());
            },
            onFailure: (message) => AppOverlay.showToast(message),
          )
          .then((value) => AppOverlay.closeProgressBar());
    }
  }
}

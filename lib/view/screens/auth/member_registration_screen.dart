import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/view/base/edit_text.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:growthpad/view/screens/requestes/requested_login.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/auth_controller.dart';
import '../../../theme/colors.dart';
import '../../../util/assets.dart';
import '../../../util/constants.dart';

class MemberRegistrationScreen extends StatefulWidget {
  final String societyId;

  const MemberRegistrationScreen({Key? key, required this.societyId}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<MemberRegistrationScreen> {
  GlobalKey<FormState> nameKey = GlobalKey();
  GlobalKey<FormState> emailKey = GlobalKey();
  GlobalKey<FormState> passwordKey = GlobalKey();
  GlobalKey<FormState> confirmKey = GlobalKey();
  GlobalKey<FormState> blockKey = GlobalKey();
  GlobalKey<FormState> houseNoKey = GlobalKey();

  String name = '';
  String email = '';
  String password = '';
  String confirm = '';
  String block = '';
  String houseNo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.onPrimaryColor,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), color: AppColors.secondaryColor, onPressed: Get.back),
        title: Row(
          children: [
            Image.asset(Assets.growthpadLogo, width: 35, height: 35),
            const SizedBox(width: 8),
            const Text(
              "Growth",
              style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w900),
            ),
            const Text(
              "Pad",
              style: TextStyle(color: AppColors.secondaryColor, fontWeight: FontWeight.w900),
            ),
          ],
        ),
      ),
      body: GetBuilder<AuthController>(
        init: Get.find<AuthController>(),
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 12),
                const Text('Your Details', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                EditText(
                  label: 'Name',
                  inputType: TextInputType.name,
                  formKey: nameKey,
                  onChange: (value) => name = value ?? '',
                  errorText: 'Enter name',
                ),
                EditText(
                  label: 'Email',
                  inputType: TextInputType.emailAddress,
                  formKey: emailKey,
                  onChange: (value) => email = value ?? '',
                  errorText: 'Enter email',
                  validateEmail: true,
                ),
                EditText(
                  label: 'Password',
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                  formKey: passwordKey,
                  onChange: (value) => password = value ?? '',
                  errorText: 'Enter password',
                  validatePassword: true,
                ),
                EditText(
                  label: 'Confirm Password',
                  inputType: TextInputType.visiblePassword,
                  obscureText: true,
                  formKey: confirmKey,
                  onChange: (value) => confirm = value ?? '',
                  errorText: 'Enter password',
                  validatePassword: true,
                ),
                const SizedBox(height: 12),
                const Text('House Details', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                EditText(
                  label: 'Block',
                  inputType: TextInputType.text,
                  formKey: blockKey,
                  onChange: (value) => block = value ?? '',
                ),
                EditText(
                  label: 'House No',
                  inputType: TextInputType.number,
                  formKey: houseNoKey,
                  onChange: (value) => houseNo = value ?? '',
                  errorText: 'Enter house number',
                ),
                const SizedBox(height: 16),
                FilledButton(
                  text: 'Register',
                  onClick: onRegisterClick,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void onRegisterClick() {
    if (validate()) {
      register();
    }
  }

  bool validate() {
    bool name = nameKey.currentState?.validate() ?? false;
    bool email = emailKey.currentState?.validate() ?? false;
    bool password = passwordKey.currentState?.validate() ?? false;
    bool confirm = confirmKey.currentState?.validate() ?? false;
    bool block = blockKey.currentState?.validate() ?? true;
    bool houseNo = houseNoKey.currentState?.validate() ?? false;
    bool pwdMatch = this.password == this.confirm;

    if (!pwdMatch) {
      AppOverlay.showToast('Password does not match');
    }

    return (name && email && password && confirm && block && houseNo && pwdMatch);
  }

  Future<void> register() async {
    AppOverlay.showProgressBar();
    Get.find<AuthController>()
        .memberRegister(
          email: email,
          password: password,
          name: name,
          societyId: widget.societyId,
          block: block,
          houseNo: houseNo,
          onSuccess: (user) {
            Log.console('Member: $user');
            Get.find<SharedPreferences>().setString(Constant.spType, UserType.temp.toString());
            Get.find<SharedPreferences>().setString(Constant.spUser, user.toJson());
            Get.put(UserType.temp, permanent: true);
            Get.put(user, permanent: true);
            Get.offAll(() => const RequestedLogin());
          },
          onFailure: AppOverlay.showToast,
        )
        .then((value) => AppOverlay.closeProgressBar());
  }
}

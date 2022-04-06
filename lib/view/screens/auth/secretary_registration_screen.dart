import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/view/base/edit_text.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controller/auth_controller.dart';
import '../../../theme/colors.dart';
import '../../../util/assets.dart';
import '../../../util/constants.dart';

class SecretaryRegistrationScreen extends StatefulWidget {
  const SecretaryRegistrationScreen({Key? key}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<SecretaryRegistrationScreen> {
  GlobalKey<FormState> nameKey = GlobalKey();
  GlobalKey<FormState> emailKey = GlobalKey();
  GlobalKey<FormState> passwordKey = GlobalKey();
  GlobalKey<FormState> confirmKey = GlobalKey();
  GlobalKey<FormState> socNameKey = GlobalKey();
  GlobalKey<FormState> addressKey = GlobalKey();
  GlobalKey<FormState> houseNoKey = GlobalKey();

  String name = '';
  String email = '';
  String password = '';
  String confirm = '';
  String socName = '';
  String address = '';
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
                const Text('Secretary Details', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
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
                const Text('Society Details', style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                EditText(
                  label: 'Society Name',
                  inputType: TextInputType.name,
                  formKey: socNameKey,
                  onChange: (value) => socName = value ?? '',
                  errorText: 'Enter society name',
                ),
                EditText(
                  label: 'Address',
                  inputType: TextInputType.streetAddress,
                  formKey: addressKey,
                  onChange: (value) => address = value ?? '',
                  errorText: 'Enter address',
                ),
                EditText(
                  label: 'No of Houses',
                  inputType: TextInputType.number,
                  formKey: houseNoKey,
                  onChange: (value) => houseNo = value ?? '',
                  errorText: 'Enter number',
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
    bool socName = socNameKey.currentState?.validate() ?? false;
    bool address = addressKey.currentState?.validate() ?? false;
    bool houseNo = houseNoKey.currentState?.validate() ?? false;
    bool pwdMatch = this.password == this.confirm;

    if (!pwdMatch) {
      AppOverlay.showToast('Password does not match');
    }

    return (name && email && password && confirm && socName && address && houseNo && pwdMatch);
  }

  Future<void> register() async {
    AppOverlay.showProgressBar();
    Get.find<AuthController>()
        .secretaryRegister(
          email: email,
          password: password,
          name: name,
          socName: socName,
          address: address,
          houseNo: houseNo,
          onSuccess: (user, society) {
            Log.console('Secretary: $user');
            Log.console('Society: $society');
            Get.find<SharedPreferences>().setString(Constant.spType, UserType.secretary.toString());
            Get.find<SharedPreferences>().setString(Constant.spUser, user.toJson());
          },
          onFailure: AppOverlay.showToast,
        )
        .then((value) => AppOverlay.closeProgressBar());
  }
}
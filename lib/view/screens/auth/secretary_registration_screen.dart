import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/service/notification_service.dart';
import 'package:growthpad/helper/log.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/view/base/edit_text.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/controller/auth_controller.dart';
import '../../../theme/colors.dart';
import '../../../util/assets.dart';
import '../../../util/constants.dart';
import '../secretary_home/home.dart';

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
  GlobalKey<FormState> accountKey = GlobalKey();
  GlobalKey<FormState> ifscKey = GlobalKey();

  String name = '';
  String email = '';
  String password = '';
  String confirm = '';
  String socName = '';
  String address = '';
  String houseNo = '';
  String account = '';
  String ifsc = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.cardColor,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new), color: AppColors.onSecondaryColor, onPressed: Get.back),
        title: Row(
          children: [
            Image.asset(Assets.growthpadLogo, width: 35, height: 35),
            const SizedBox(width: 8),
            const Text(
              "Growth",
              style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w900),
            ),
            Text(
              "Pad",
              style: TextStyle(color: AppColors.onSecondaryColor, fontWeight: FontWeight.w900),
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
                EditText(
                  label: 'Account Number',
                  inputType: TextInputType.number,
                  formKey: accountKey,
                  onChange: (value) => account = value ?? '',
                  errorText: 'Enter account number',
                ),
                EditText(
                  label: 'Ifsc',
                  inputType: TextInputType.text,
                  formKey: ifscKey,
                  onChange: (value) => ifsc = value ?? '',
                  errorText: 'Enter valid ifsc',
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
    bool account = accountKey.currentState?.validate() ?? false;
    bool ifsc = ifscKey.currentState?.validate() ?? false;
    bool pwdMatch = this.password == this.confirm;

    if (!pwdMatch) {
      AppOverlay.showToast('Password does not match');
    }

    return (name && email && password && confirm && socName && address && houseNo && pwdMatch && account && ifsc);
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
          account: account,
          ifsc: ifsc,
          onSuccess: (user, society) {
            Log.console('Secretary: $user');
            Log.console('Society: $society');
            NotificationService.subscribe(user.id, society.id);
            Get.find<SharedPreferences>().setString(Constant.spType, UserType.secretary.toString());
            Get.find<SharedPreferences>().setString(Constant.spUser, user.toJson());
            Get.put(UserType.secretary, permanent: true);
            Get.put(user, permanent: true);
            Get.offAll(() => const SecretaryHome());
          },
          onFailure: AppOverlay.showToast,
        )
        .then((value) => AppOverlay.closeProgressBar());
  }
}

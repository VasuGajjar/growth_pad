import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/controller/auth_controller.dart';
import 'package:growthpad/data/model/member.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/util/constants.dart';
import 'package:growthpad/view/screens/member_home/home.dart';

import '../../../theme/colors.dart';
import '../../../util/assets.dart';

class RequestedLogin extends StatefulWidget {
  const RequestedLogin({Key? key}) : super(key: key);

  @override
  State<RequestedLogin> createState() => _RequestedLoginState();
}

class _RequestedLoginState extends State<RequestedLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.onPrimaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.onPrimaryColor,
        title: Row(
          children: [
            Image.asset(Assets.growthpadLogo, width: 35, height: 35),
            const SizedBox(width: 8),
            const Text("Growth", style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w900)),
            const Text("Pad", style: TextStyle(color: AppColors.secondaryColor, fontWeight: FontWeight.w900)),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: checkForApproval,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Requested for Login',
                style: TextStyles.h2Bold,
              ),
              SizedBox(height: 8),
              Text(
                'We have Notified the Society Secretary for reviewing your request.',
                style: TextStyles.p1Normal,
              ),
              SizedBox(height: 4),
              Text(
                'We will notify you when Secretart accepts your request.',
                style: TextStyles.p1Normal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> checkForApproval() async {
    var user = await Get.find<AuthController>().searchMember(Get.find<Member>().id);

    if (user != null) {
      Get.replace(UserType.member);
      Get.replace(user);
      Get.offAll(() => const MemberHome());
    }
  }
}

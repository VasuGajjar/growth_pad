import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/core/controller/auth_controller.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/util/constants.dart';
import 'package:growthpad/view/base/resizable_scrollview.dart';
import 'package:growthpad/view/screens/member_home/home.dart';
import 'package:growthpad/view/screens/splash/user_select_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        actions: [
          TextButton(
            child: const Text('Logout'),
            onPressed: () async {
              AppOverlay.showProgressBar();
              await Get.find<AuthController>().logout(UserType.temp);
              AppOverlay.closeProgressBar();
              Get.offAll(() => const UserSelectScreen());
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: checkForApproval,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResizableScrollView(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: LottieBuilder.asset(
                  Assets.success,
                  height: 160,
                  repeat: false,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Requested for Login',
                style: TextStyles.h2Bold,
              ),
              const SizedBox(height: 8),
              const Text(
                'We have Notified the Society Secretary for reviewing your request.',
                style: TextStyles.p1Normal,
              ),
              const SizedBox(height: 4),
              const Text(
                'We will notify you when Secretary accepts your request.',
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
      await Get.find<SharedPreferences>().setString(Constant.spType, UserType.member.toString());
      Get.replace(UserType.member);
      Get.replace(user);
      Get.offAll(() => const MemberHome());
    }
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/data/model/member.dart';
import 'package:growthpad/data/model/secretary.dart';
import 'package:growthpad/util/constants.dart';
import 'package:growthpad/view/screens/requestes/requested_login.dart';
import 'package:growthpad/view/screens/member_home/home.dart';
import 'package:growthpad/view/screens/secretary_home/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/log.dart';
import '../../../util/assets.dart';
import 'user_select_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<double>(
            future: changeOpacity(),
            builder: (context, snapshot) {
              return AnimatedOpacity(
                duration: 2.seconds,
                opacity: snapshot.data ?? 0,
                onEnd: onAnimationEnd,
                curve: Curves.easeOut,
                child: Image.asset(Assets.growthpadLogo, height: 120, width: 120),
              );
            }),
      ),
    );
  }

  Future<double> changeOpacity() async {
    await Future.delayed(200.milliseconds);
    return 1;
  }

  Future<void> onAnimationEnd() async {
    var userType = Get.find<SharedPreferences>().getString(Constant.spType);
    var user = Get.find<SharedPreferences>().getString(Constant.spUser);

    Log.console('UserType: $userType');
    Log.console('User: $user');

    if (userType != null && user != null) {
      if (userType == UserType.member.toString()) {
        Get.put(UserType.member, permanent: true);
        Get.put(Member.fromJson(user), permanent: true);
        Get.offAll(() => const MemberHome());
      } else if (userType == UserType.temp.toString()) {
        Get.put(UserType.temp, permanent: true);
        Get.put(Member.fromJson(user), permanent: true);
        Get.offAll(() => const RequestedLogin());
      } else if (userType == UserType.secretary.toString()) {
        Get.put(UserType.secretary, permanent: true);
        Get.put(Secretary.fromJson(user), permanent: true);
        Get.offAll(() => const SecretaryHome());
      } else {
        Get.offAll(() => const UserSelectScreen());
      }
    } else {
      Get.offAll(() => const UserSelectScreen());
    }
  }
}

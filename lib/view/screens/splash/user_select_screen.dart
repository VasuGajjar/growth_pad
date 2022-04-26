import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/filled_button.dart';

import '../../../theme/colors.dart';
import '../../../util/assets.dart';
import '../../../util/constants.dart';
import '../auth/login_screen.dart';

class UserSelectScreen extends StatefulWidget {
  const UserSelectScreen({Key? key}) : super(key: key);

  @override
  _UserSelectScreenState createState() => _UserSelectScreenState();
}

class _UserSelectScreenState extends State<UserSelectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardColor,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 80, left: 16, right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset(Assets.growthpadLogo, width: 80, height: 80, alignment: Alignment.centerLeft),
            Row(
              children: [
                const Text("Growth", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: AppColors.primaryColor)),
                Text("Pad", style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900, color: AppColors.onSecondaryColor)),
              ],
            ),
            Text('Society Maintenance Management System', style: TextStyles.p2Normal),
            const SizedBox(height: 60),
            FilledButton(
              text: 'Society Member',
              onClick: () => Get.to(() => const LoginScreen(userType: UserType.member)),
            ),
            FilledButton(
              text: 'Society Secretary',
              onClick: () => Get.to(() => const LoginScreen(userType: UserType.secretary)),
            ),
          ],
        ),
      ),
    );
  }
}

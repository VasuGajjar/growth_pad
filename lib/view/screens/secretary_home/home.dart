import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growthpad/core/controller/auth_controller.dart';
import 'package:growthpad/core/model/secretary.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/util/assets.dart';
import 'package:growthpad/util/constants.dart';
import 'package:growthpad/view/base/home_item_tile.dart';
import 'package:growthpad/view/screens/chat/chat_screen.dart';
import 'package:growthpad/view/screens/maintenance/maintenance_screen.dart';
import 'package:growthpad/view/screens/requestes/request_list.dart';
import 'package:growthpad/view/screens/splash/user_select_screen.dart';

import '../../base/filled_button.dart';

class SecretaryHome extends StatefulWidget {
  const SecretaryHome({Key? key}) : super(key: key);

  @override
  State<SecretaryHome> createState() => _SecretaryHomeState();
}

class _SecretaryHomeState extends State<SecretaryHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        shadowColor: AppColors.backgroundColor.withOpacity(0.5),
        systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent),
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Image.asset(Assets.growthpadLogo, height: 40, width: 40),
            ),
            Text.rich(
              const TextSpan(text: 'Growth', children: [
                TextSpan(text: 'Pad', style: TextStyle(color: AppColors.secondaryColor)),
              ]),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.gear_solid),
          )
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: const Icon(
                CupertinoIcons.person_fill,
                color: AppColors.backgroundColor,
                size: 24,
              ),
              backgroundColor: AppColors.primaryColor.withOpacity(0.7),
            ),
            title: Text(
              'Hello, ${Get.find<Secretary>().name}',
              style: TextStyles.p1Bold,
            ),
            subtitle: Text(Get.find<Secretary>().email),
            trailing: FilledButton(
              text: 'Logout',
              onClick: () async {
                AppOverlay.showProgressBar();
                await Get.find<AuthController>().logout(UserType.secretary);
                AppOverlay.closeProgressBar();
                Get.offAll(() => const UserSelectScreen());
              },
              backgroundColor: AppColors.primaryColor.withOpacity(0.3),
              textColor: AppColors.primaryColor,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
              margin: const EdgeInsets.symmetric(vertical: 12),
            ),
          ),
          Expanded(
            child: GridView(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              children: [
                HomeItemTile(
                  animationName: Assets.maintenance,
                  title: 'Maintenance',
                  onTap: () => Get.to(() => const MaintenanceScreen()),
                ),
                HomeItemTile(
                  animationName: Assets.requestList,
                  title: 'Pending Requests',
                  onTap: () => Get.to(() => const RequestList()),
                ),
                HomeItemTile(
                  animationName: Assets.chat,
                  title: 'General Chat',
                  onTap: () => Get.to(() => ChatScreen(societyId: Get.find<Secretary>().sid)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

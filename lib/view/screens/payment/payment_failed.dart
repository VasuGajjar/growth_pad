import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/util/assets.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:growthpad/view/base/resizable_scrollview.dart';
import 'package:growthpad/view/screens/member_home/home.dart';
import 'package:lottie/lottie.dart';

import '../../../core/model/maintenance.dart';

class PaymentFailed extends StatelessWidget {
  final Maintenance maintenance;
  final String message;

  const PaymentFailed({Key? key, required this.maintenance, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Image.asset(Assets.growthpadLogo, height: 40, width: 40),
            ),
            Text.rich(
              const TextSpan(text: 'Growth', children: [TextSpan(text: 'Pad', style: TextStyle(color: AppColors.secondaryColor))]),
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      ),
      body: ResizableScrollView(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset(
                Assets.fail,
                height: 200,
                repeat: false,
              ),
              Text(
                'Payment Failed',
                style: TextStyles.h3Bold.copyWith(color: AppColors.secondaryColor),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text('Reason : $message', style: TextStyles.p2Normal),
          ),
          titleText('Maintenance Id :', maintenance.id),
          titleText('Society Id :', maintenance.sid),
          titleText('Amount :', 'Rs. ${maintenance.amount}'),
          titleText('Maintenance Month :', '${maintenance.month} ${maintenance.year}'),
          titleText('Payment by :', Get.find<Member>().name),
          titleText('House :', '${Get.find<Member>().block}  ${Get.find<Member>().houseNo}'),
          const Spacer(),
          FilledButton(
            text: 'Try Again',
            margin: const EdgeInsets.all(20).copyWith(bottom: 10),
            padding: const EdgeInsets.all(16),
            backgroundColor: AppColors.warningColor,
            onClick: () {},
          ),
          FilledButton(
            text: 'Go Home',
            margin: const EdgeInsets.all(20).copyWith(top: 0),
            padding: const EdgeInsets.all(16),
            onClick: () => Get.offAll(() => const MemberHome()),
          ),
        ],
      ),
    );
  }

  Widget titleText(String title, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyles.p2Normal,
          ),
          const Spacer(),
          Text(
            text,
            style: TextStyles.p2Bold,
          ),
        ],
      ),
    );
  }
}

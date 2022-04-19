import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:growthpad/core/controller/maintenance_controller.dart';
import 'package:growthpad/core/model/maintenance.dart';
import 'package:growthpad/core/model/member.dart';
import 'package:growthpad/core/model/payment.dart';
import 'package:growthpad/core/service/pdf_service.dart';
import 'package:growthpad/helper/date_converter.dart';
import 'package:growthpad/helper/overlay.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:growthpad/view/base/filled_button.dart';
import 'package:growthpad/view/base/resizable_scrollview.dart';
import 'package:growthpad/view/screens/member_home/home.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';

import '../../../util/assets.dart';

class PaymentSuccess extends StatelessWidget {
  final Maintenance maintenance;
  final Payment payment;

  const PaymentSuccess({
    Key? key,
    required this.maintenance,
    required this.payment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
                Assets.success,
                height: 200,
                repeat: false,
              ),
              Text(
                'Payment Successful',
                style: TextStyles.h3Bold.copyWith(color: AppColors.secondaryColor),
              ),
            ],
          ),
          const SizedBox(height: 24),
          titleText('Payment Id :', payment.id),
          titleText('Society Id :', maintenance.sid),
          titleText('Payment Date :', DateConverter.timeToString(payment.paymentTime, output: 'dd MMM yyyy  hh:mm a')),
          titleText('Amount :', 'Rs. ${payment.amount}'),
          titleText('Penalty :', payment.penalty ? 'Yes' : 'No'),
          titleText('Maintenance :', '${maintenance.month} ${maintenance.year}'),
          titleText('Payment by :', Get.find<Member>().name),
          titleText('House :', '${Get.find<Member>().block}  ${Get.find<Member>().houseNo}'),
          const Spacer(),
          FilledButton(
            text: 'Download as Pdf',
            margin: const EdgeInsets.all(20).copyWith(bottom: 10),
            padding: const EdgeInsets.all(16),
            backgroundColor: AppColors.infoColor,
            onClick: () async {
              AppOverlay.showProgressBar();

              var society = await Get.find<MaintenanceController>().findSociety(societyId: maintenance.sid);

              if (society == null) {
                AppOverlay.closeProgressBar();
                AppOverlay.showToast('Invalid Id');
                return;
              }

              PdfService.generateInvoice(
                society: society,
                user: Get.find<Member>(),
                maintenance: maintenance,
                payment: payment,
                onResult: (status, message, file) {
                  AppOverlay.closeProgressBar();
                  if (file != null) {
                    OpenFile.open(file.path);
                  } else {
                    AppOverlay.showToast(message);
                  }
                },
              );
            },
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

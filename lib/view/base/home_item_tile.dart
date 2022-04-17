import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:growthpad/theme/colors.dart';
import 'package:growthpad/theme/text_theme.dart';
import 'package:lottie/lottie.dart';

class HomeItemTile extends StatelessWidget {
  final String animationName;
  final String title;
  final void Function()? onTap;

  const HomeItemTile({
    Key? key,
    required this.animationName,
    required this.title,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      color: AppColors.cardColor,
      shadowColor: AppColors.backgroundColor.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primaryColor.withOpacity(0.3),
        highlightColor: AppColors.primaryColor.withOpacity(0.15),
        child: Column(
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(12).copyWith(bottom: 0),
              child: LottieBuilder.asset(
                animationName,
                repeat: kDebugMode ? false : true,
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: TextStyles.p2Bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

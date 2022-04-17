import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../theme/colors.dart';
import '../../util/assets.dart';

class LottieWithText extends StatelessWidget {
  final String text;
  final String animation;

  const LottieWithText({
    Key? key,
    this.animation = Assets.noSearchResults,
    this.text = 'No Data Found',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Lottie.asset(animation, width: 200, height: 200, repeat: false),
        const SizedBox(height: 12),
        Text(
          text,
          style: TextStyle(color: AppColors.secondaryColor.withOpacity(0.6), fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

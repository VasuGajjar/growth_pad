import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:growthpad/theme/colors.dart';

class Progressbar extends StatelessWidget {
  const Progressbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40 + 24,
      width: 40 + 24,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.cardColor, shape: BoxShape.circle),
      child: const SpinKitFadingFour(color: AppColors.primaryColor, size: 35),
    );
  }
}

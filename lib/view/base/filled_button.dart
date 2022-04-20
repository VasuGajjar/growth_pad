import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class FilledButton extends StatelessWidget {
  final String text;
  final Function()? onClick;
  final Color backgroundColor;
  final Color textColor;
  final Color? shadowColor;
  final EdgeInsetsGeometry padding, margin;

  const FilledButton({
    Key? key,
    required this.text,
    this.onClick,
    this.shadowColor,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = AppColors.onPrimaryColor,
    this.padding = const EdgeInsets.all(14),
    this.margin = const EdgeInsets.only(bottom: 12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: ElevatedButton(
        onPressed: onClick,
        // child: Padding(
        //   padding: padding,
        child: Text(text, style: TextStyle(fontSize: 16, color: textColor)),
        // ),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          shadowColor: shadowColor ?? backgroundColor.withOpacity(0.4),
          primary: backgroundColor,
          elevation: 0,
          padding: padding,
        ),
      ),
    );
  }
}

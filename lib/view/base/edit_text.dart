import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:growthpad/theme/text_theme.dart';

class EditText extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController? textController;
  final String label;
  final String? errorText;
  final bool obscureText, validateEmail, validatePassword;
  final void Function(String?) onChange;
  final TextInputType inputType;

  const EditText({
    Key? key,
    this.formKey,
    this.textController,
    this.errorText,
    this.validateEmail = false,
    this.validatePassword = false,
    required this.label,
    required this.onChange,
    this.inputType = TextInputType.text,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: textController,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), counterText: ''),
          onChanged: onChange,
          autofocus: true,
          keyboardType: inputType,
          textInputAction: TextInputAction.next,
          style: TextStyles.p1Normal,
          obscureText: obscureText,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return errorText;
            }
            if (validateEmail && !value.isEmail) {
              return 'Enter valid email';
            }
            if (validatePassword && value.length < 6) {
              return 'Enter valid password';
            }
            return null;
          },
        ),
      ),
    );
  }
}

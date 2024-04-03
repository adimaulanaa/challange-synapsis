import 'package:flutter/material.dart';
import 'package:synapsis/utils/colors.dart';
import 'package:synapsis/utils/text_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Color textColor;
  final Color btnBgColor;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.textColor,
    required this.btnBgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Center(
          child: Text(
            text,
            style: blackTextstyle.copyWith(
              color: textColor,
              fontSize: 16,
              fontWeight: semiBold,
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          // ignore: deprecated_member_use
          primary: btnBgColor,
          shadowColor: Colors.transparent,
          side: const BorderSide(
            color: AppColors.borderColor,
          ),
        ),
      ),
    );
  }
}

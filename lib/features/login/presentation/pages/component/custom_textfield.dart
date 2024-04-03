import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:synapsis/utils/colors.dart';
import 'package:synapsis/utils/text_style.dart';

class CustomTextField extends StatefulWidget {
  final Color? color;
  final String hintText;
  final String? initValue;
  final String name;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final IconData? icon;
  final IconData? preffixIcon;
  final Color? iconColor;
  final Function()? onPressIcon;
  final Function(String?)? onSaved;
  const CustomTextField({
    Key? key,
    required this.hintText,
    this.initValue,
    required this.name,
    this.onChanged,
    this.validator,
    this.color,
    this.controller,
    this.obscureText = false,
    this.icon,
    this.preffixIcon,
    this.iconColor,
    this.onPressIcon,
    this.onSaved,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Expanded(
            child: FormBuilderTextField(
              name: widget.name,
              initialValue: widget.initValue,
              obscureText: widget.obscureText,
              controller: widget.controller,
              onSaved: widget.onSaved,
              validator: widget.validator,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: AppColors.borderColor,
                  ),
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                ),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(
                    10,
                  ),
                  child: Icon(
                    widget.preffixIcon,
                    color: AppColors.primaryColor,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: widget.onPressIcon,
                  icon: Icon(
                    widget.icon,
                    color: widget.iconColor,
                  ),
                  visualDensity: VisualDensity.compact,
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                hintText: widget.hintText,
                hintStyle: greyTextstyle.copyWith(
                  fontSize: 14,
                ),
              ),
              style: blackTextstyle.copyWith(
                fontSize: 16,
                fontWeight: medium,
              ),
            ),
          )
        ],
      ),
    );
  }
}

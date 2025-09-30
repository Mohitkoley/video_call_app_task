import 'package:flutter/material.dart';
import 'package:video_calling/core/extension/context_ext.dart';
import 'package:video_calling/core/shared/constraints/common_constraints.dart';
import 'package:video_calling/core/shared/constraints/common_padding.dart'
    show CommonPadding;
import 'package:video_calling/core/theme/color_pallette.dart';
import 'package:video_calling/core/typedef/k_typedef.dart';

class CommonTextField extends StatelessWidget {
  CommonTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.validator,
    this.maxLines,
    this.prefixWidget,
    this.onChanged,
    this.prefixText,
    this.suffixWidget,
    this.textAlign = TextAlign.start,
    this.keyboardType = TextInputType.text,
    this.onTap,
    this.contentPadding,
    this.onTapOutside,
    this.enabled,
    this.obscureText,
    this.errorWidget,
    this.labelText,
    this.changeObsecure,
  }) : assert(obscureText != null ? changeObsecure != null : true);
  final String hintText;
  final TextEditingController controller;
  final Validator validator;
  final int? maxLines;
  final Widget? prefixWidget;
  final Widget? suffixWidget;
  final void Function(String)? onChanged;
  final TextAlign textAlign;
  final String? prefixText;
  final TextInputType keyboardType;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(PointerDownEvent)? onTapOutside;
  Widget? errorWidget;
  bool? enabled;
  bool? obscureText;
  String? labelText;
  VoidCallback? changeObsecure;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      textAlign: textAlign,
      enabled: enabled ?? true,
      style: context.bodyMedium.copyWith(fontWeight: FontWeight.w500),
      validator: validator,
      maxLines: maxLines ?? 1,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: keyboardType,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
        onTapOutside?.call(event);
      },
      cursorErrorColor: Colors.red,
      obscureText: obscureText ?? false,
      obscuringCharacter: "*",
      decoration: InputDecoration(
        // hintStyle: context.bodyMedium.copyWith(
        //   fontSize: 14,
        //   color: ColorPalette.greyIconColor,
        // ),
        labelText: labelText ?? hintText,
        prefixText: prefixText,
        labelStyle: context.bodyMedium.copyWith(
          fontSize: 16,
          color: ColorPalette.greyIconColor,
        ),
        prefixStyle: context.bodyMedium.copyWith(
          fontSize: 16,
          color: ColorPalette.greyIconColor,
        ),
        prefixIcon: prefixWidget,
        constraints: CommonConstraints.textFieldBoxConstraints,
        // prefix: prefixWidget,
        prefixIconConstraints: CommonConstraints.textFieldPrefixConstraints,
        hintText: hintText,
        prefixIconColor: ColorPalette.greyIconColor,
        suffixIcon: obscureText != null
            ? IconButton(
                onPressed: () {
                  changeObsecure?.call();
                },
                icon: Icon(
                  color: ColorPalette.greyIconColor,
                  obscureText! ? Icons.visibility_off : Icons.visibility,
                ),
              )
            : suffixWidget,
        suffixIconConstraints: CommonConstraints.textFieldSuffixConstraints,
        contentPadding: contentPadding ?? CommonPadding.commonTextFieldPadding,
      ),
    );
  }
}

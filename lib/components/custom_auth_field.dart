import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String hintText;
  final String iconAsset;
  final bool obscureText;
  final String? Function(String?)? validator;
  final ValueChanged<bool>? onObscureTextChanged;
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.keyboardType,
    required this.hintText,
    required this.iconAsset,
    this.obscureText = false, 
    this.validator,
    this.onObscureTextChanged,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      obscureText: _obscureText,
      validator: widget.validator,
      decoration: InputDecoration(
        prefixIcon: SvgPicture.asset(
          widget.iconAsset,
          height: 16,
          width: 20,
          fit: BoxFit.none,
        ),
        hintText: widget.hintText,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  size: 15,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                  widget.onObscureTextChanged?.call(_obscureText);
                },
              )
            : null,
      ),
    );
  }
}

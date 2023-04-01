import 'package:flutter/material.dart';

import '../theming/app_dimms.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color color;
  final String? Function(String?) validator;
  final TextInputType keyboardType;
  final String? hintText;

  AppTextField({
    Key? key,
    required this.label,
    required this.controller,
    required this.color,
    required this.validator,
    required this.keyboardType,
    this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDims.mediumSmallPadding),
      child: TextFormField(
        onTap: () {},
        cursorWidth: 2,
        keyboardType: keyboardType,
        controller: controller,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText ?? '',
          hintStyle: Theme.of(context).textTheme.bodyMedium,
          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(AppDims.mediumSmallBorderRadius),
          ),
          label: Text(
            label,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ),
    );
  }
}

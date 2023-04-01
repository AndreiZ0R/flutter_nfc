import 'package:flutter/material.dart';

import '../theming/app_dimms.dart';

class AppCheckbox extends StatelessWidget {
  final String label;
  final Function(bool?) onChanged;
  final Color color;
  final bool isSelected;

  const AppCheckbox({
    Key? key,
    required this.label,
    required this.onChanged,
    required this.color,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDims.mediumSmallPadding),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: color,
                ),
          ),
          const SizedBox(width: AppDims.extraSmallPadding),
          Checkbox(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDims.smallBorderRadius),
            ),
            fillColor: MaterialStateProperty.resolveWith((states) => color),
            value: isSelected,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }
}

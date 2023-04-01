import 'package:flutter/material.dart';

import '../theming/app_dimms.dart';

class FrontRow extends StatelessWidget {
  final String display;
  final VoidCallback onPressed;

  const FrontRow({
    Key? key,
    required this.display,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back,',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              display,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppDims.defaultBorderRadius,
              ),
            ),
          ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppDims.mediumSmallPadding,
            ),
            child: Icon(
              Icons.menu_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        )
      ],
    );
  }
}
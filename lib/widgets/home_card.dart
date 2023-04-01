import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/home_model.dart';
import '../theming/app_dimms.dart';
import '../theming/app_theme.dart';

class HomeCard extends StatefulWidget {
  final Color backgroundColor;
  final HomeModel home;
  final Function(DismissDirection?) onDismissed;

  HomeCard({
    Key? key,
    required this.backgroundColor,
    required this.home,
    required this.onDismissed,
  }) : super(key: key);

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDims.mediumSmallPadding),
      child: Dismissible(
        key: ValueKey(widget.home),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: AppTheme.errorColor,
            borderRadius: BorderRadius.circular(AppDims.defaultBorderRadius),
          ),
          padding: const EdgeInsets.only(right: AppDims.defaultPadding),
          child: const Icon(
            Icons.delete_forever_rounded,
            color: Colors.white,
          ),
        ),
        onDismissed: widget.onDismissed,
        child: Container(
          decoration: BoxDecoration(
            boxShadow: const [AppTheme.defaultBoxShadow],
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(AppDims.defaultBorderRadius),
          ),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(AppDims.defaultPadding),
          // duration: const Duration(milliseconds: 400),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.home.name,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: _isExpanded ? 20 : 19,
                          fontWeight:
                              _isExpanded ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                  Row(
                    children: [
                      Icon(
                        widget.home.isLocked
                            ? Icons.lock_outlined
                            : Icons.lock_open_rounded,
                        color: widget.home.isLocked
                            ? AppTheme.succesColor
                            : AppTheme.errorColor,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        icon: const Icon(Icons.keyboard_arrow_down_rounded),
                        color: Theme.of(context).colorScheme.secondary,
                      )
                    ],
                  ),
                ],
              ),
              if (_isExpanded)
                Padding(
                  padding:
                      const EdgeInsets.only(top: AppDims.mediumSmallPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(
                          bottom: AppDims.defaultPadding,
                        ),
                        child: Divider(
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'Currently ${widget.home.isLocked ? 'locked' : 'not locked'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: widget.home.isLocked
                                  ? AppTheme.succesColor
                                  : AppTheme.errorColor,
                            ),
                      ),
                      Text(
                        'Address: ${widget.home.location}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Text(
                        'Owner: ${widget.home.owner}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Text(
                        'Last checked: ${DateFormat('dd-MMMM-yyyy hh:mm a').format(widget.home.lastChecked)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';
import 'package:frontend/utils/all_utils.dart';

/// Custom action button used in [HomePage].
class SpqFloatingActionButton extends StatelessWidget {
  final Widget child;
  final String heroTag;
  final void Function() onPressed;

  const SpqFloatingActionButton({
    Key? key,
    required this.onPressed,
    required this.child,
    required this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: spqPrimaryBlue,
      foregroundColor: spqWhite,
      onPressed: onPressed,
      heroTag: heroTag,
      child: child,
    );
  }
}

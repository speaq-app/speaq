import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';

class SpqFloatingActionButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  final String heroTag;

  const SpqFloatingActionButton({Key? key, required this.onPressed, required this.child, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(backgroundColor: spqPrimaryBlue, foregroundColor: spqWhite,onPressed: onPressed, child: child, heroTag: heroTag,);
  }
}
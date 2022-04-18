import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';

class SpqFloatingActionButton extends StatelessWidget {
  final Widget child;
  final String heroTag;

  const SpqFloatingActionButton({Key? key, required this.child, required this.heroTag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(backgroundColor: spqPrimaryBlue, foregroundColor: spqWhite, onPressed: ()=> Navigator.pushNamed(context, "new_post"), child: child, heroTag: heroTag,);
  }
}

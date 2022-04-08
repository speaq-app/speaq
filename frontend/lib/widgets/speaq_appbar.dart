import 'package:flutter/material.dart';

class SpqAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SpqAppBar({
    Key? key,
    required ScrollController scrollController,
    required this.preferredSize,
    this.actionList,
    this.leading,
    required this.title,
  }) : super(key: key);

  @override
  final Size preferredSize;
  final List<Widget>? actionList;
  final Widget? leading;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SizedBox( height: deviceSize.height * 0.15,
      child: AppBar(
        toolbarHeight: deviceSize.height * 0.15,
        title: title,
        backgroundColor: Colors.white,
        elevation: 4.0,
        actions: actionList,
        leading: leading,
      ),
    );
  }
}

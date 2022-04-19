import 'package:flutter/material.dart';

class SpqAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final List<Widget>? actionList;
  final Widget? leading;
  final Widget title;
  final TabBar? bottom;
  final bool? centerTitle;
  final double? leadingWidth;
  final bool isAutomaticallyImplyLeading;

  const SpqAppBar({
    Key? key,
    required this.preferredSize,
    this.actionList,
    this.leading,
    this.isAutomaticallyImplyLeading = true,
    required this.title,
    this.bottom,
    this.centerTitle,
    this.leadingWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height * 0.075,
      child: AppBar(
        automaticallyImplyLeading: isAutomaticallyImplyLeading,
        leadingWidth: leadingWidth,
        centerTitle: centerTitle,
        toolbarHeight: preferredSize.height * 0.075,
        title: title,
        backgroundColor: Colors.white,
        elevation: 4.0,
        actions: actionList,
        leading: leading,
        bottom: bottom,
      ),
    );
  }
}

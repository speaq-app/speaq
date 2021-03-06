import 'package:flutter/material.dart';
import 'package:frontend/pages/all_pages_export.dart';

/// Custom appbar used for instance in all Main-Pages and [ProfilePage].
class SpqAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;
  final List<Widget>? actionList;
  final Widget? leading;
  final Widget? title;
  final TabBar? bottom;
  final bool? centerTitle;
  final double? leadingWidth;
  final bool automaticallyImplyLeading;

  const SpqAppBar({
    Key? key,
    required this.preferredSize,
    this.actionList,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.bottom,
    this.centerTitle,
    this.leadingWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: preferredSize.height * 0.075,
      child: AppBar(
        automaticallyImplyLeading: automaticallyImplyLeading,
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

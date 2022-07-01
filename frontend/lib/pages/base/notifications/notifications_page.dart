import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

/// The notification page is not yet implemented.
class _NotificationsPageState extends State<NotificationsPage> {
  final String langKey = "pages.base.notifications.";

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          leading: null,
          automaticallyImplyLeading: false,
          preferredSize: deviceSize,
        ),
        backgroundColor: spqPrimaryBlue,
        body: const Center(
          child: Text(
            "coming soon...",
            style: TextStyle(fontSize: 25),
          ),
        ),
      ),
    );
  }
}

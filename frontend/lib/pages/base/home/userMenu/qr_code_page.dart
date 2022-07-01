import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class QrCodePage extends StatefulWidget {
  const QrCodePage({Key? key}) : super(key: key);

  @override
  State<QrCodePage> createState() => _QrCodePageState();
}

/// Creates and returns elements for [SafeArea] for the build widget.
class _QrCodePageState extends State<QrCodePage> {
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
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

import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({Key? key}) : super(key: key);

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

/// Creates and returns elements for [SafeArea] for the build widget.
class _BookmarksPageState extends State<BookmarksPage> {
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

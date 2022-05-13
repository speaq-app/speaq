import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late AppLocalizations appLocale;

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    appLocale = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          title: Text(appLocale.search, style: TextStyle(fontSize: 20)),
          preferredSize: deviceSize,
          centerTitle: true,
        ),
      ),
    );
  }
}

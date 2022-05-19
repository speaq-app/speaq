import 'package:flutter/material.dart';
import 'package:frontend/pages/base/messages/user.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:frontend/widgets/all_widgets.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  late AppLocalizations appLocale;
  late Size deviceSize;

  @override
  Widget build(BuildContext context) {
    deviceSize = MediaQuery.of(context).size;
    appLocale = AppLocalizations.of(context)!;

    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          title: Column(
            children: [
              Text(appLocale.search, style: TextStyle(fontSize: 20)),
              generateSearchBar(deviceSize),
            ],
          ),
          preferredSize: Size.fromHeight(1600),
          centerTitle: true,
        ),
      ),
    );
  }

  SizedBox generateSearchBar(Size deviceSize) {
    return SizedBox(
      height: deviceSize.height * 0.08,
      width: deviceSize.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: TextField(
          //onChanged: (value) => filterSearchResults(value),
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search, color: spqDarkGreyTranslucent),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
                borderSide: BorderSide.none),
            hintStyle: const TextStyle(
              fontSize: 14,
              color: spqDarkGreyTranslucent,
            ),
            hintText: appLocale.hintTextSearchBar,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/widgets/speaq_appbar.dart';
import 'package:frontend/widgets/all_widgets.dart';
import 'package:frontend/utils/all_utils.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  String profilePicture = "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

  final List<CondensedUser> _allUserList = [
    CondensedUser(name: "Hendrik"),
    CondensedUser(name: "Daniel"),
    CondensedUser(name: "Nosa"),
    CondensedUser(name: "Eric"),
    CondensedUser(name: "Sven"),
    CondensedUser(name: "David"),
    CondensedUser(name: "Martin"),
    CondensedUser(name: "Karl"),
    CondensedUser(name: "Hans"),
    CondensedUser(name: "Petra"),
    CondensedUser(name: "Steffi"),
    CondensedUser(name: "Jürgen"),
  ];
  List<CondensedUser> _foundUsersList = [];

  @override
  void initState() {
    _foundUsersList = _allUserList;
    super.initState();
  }

  late AppLocalizations appLocale;

  @override
  Widget build(BuildContext context) {
    appLocale = AppLocalizations.of(context)!;
    Size deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          title: Text(
            appLocale.messages,
            style: const TextStyle(fontSize: 20),
          ),
          preferredSize: deviceSize,
          centerTitle: true,
          actionList: [generateSettingsIcon(context)],
        ),
        body: Column(
          children: <Widget>[
            generateSearchBar(deviceSize),
            Expanded(
              child: ListView.builder(
                itemCount: _foundUsersList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: spqPrimaryBlue,
                      child: Text(_foundUsersList[index].name[0]),
                    ),
                    title: Text(
                      _foundUsersList[index].name,
                    ),
                    subtitle: const Text(
                      "Hier steht die letzte nachricht, die in diesem Chat verfasst wurde",
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Text("12:34 Uhr"),
                  );
                },
              ),
            ),
          ],
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
          onSubmitted: (value) => filterSearchResults(value),
          onChanged: (value) => filterSearchResults(value),
          decoration: InputDecoration(
            filled: true,
            prefixIcon: const Icon(Icons.search, color: spqDarkGreyTranslucent),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50), borderSide: BorderSide.none),
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

  IconButton generateSettingsIcon(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings),
      color: Colors.blue,
      iconSize: 25,
      onPressed: () => {
        Navigator.pushNamed(context, "notificationSettings"),
      },
    );
  }

  filterSearchResults(String? text) {
    List<CondensedUser> filterList = <CondensedUser>[];
    if (text != null && text.isNotEmpty) {
      setState(() {
        filterList.addAll(_allUserList.where((user) => user.name.toString().toLowerCase().contains(text.toLowerCase())).toList());
        _foundUsersList = filterList;
      });
    } else {
      setState(() {
        _foundUsersList = _allUserList;
      });
    }
  }
}

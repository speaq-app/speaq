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
  List<User> _allUserList = [
    User(
        "https://www.cleverfiles.com/howto/wp-content/uploads/2018/03/minion.jpg",
        "Sven Gatnar",
        "Ich bin so ein geiler Typ",
        "12:20"),
    User(
        "https://hotdogworld.de/media/image/dd/5f/5f/HZ_TK_500ml_USD_1280x1280.jpg",
        "Halois Ainz",
        "Ich kenne jeden Automaten den es gibt",
        "12:33"),
    User(
        "http://staffmobility.eu/sites/default/files/isewtweetbg.jpg",
        "Hendrik Schlehlein",
        "Daily-Meetings verlaufen nicht so gut",
        "01.01.2020"),
    User(
        "https://upload.wikimedia.org/wikipedia/commons/c/c9/Moon.jpg",
        "Nosakhare Omoruyi",
        "Ich bin der allerbeste Programmiererer",
        "20.04.2020"),
    User("https://img1.dreamies.de/img/21/b/p4el6oypvd7.jpg", "David Löwe",
        "Elvis ist mein Ein und Alles", "03.01.2020"),
    User("https://www.meinkleinesparadies.de/images/52/07.02.16-026.JPG",
        "Eric Eisemann", "Ich hätte gerne einen Bart und eine Glatze", "15:30"),
    User(
        "https://www.rollingstone.co.uk/wp-content/uploads/sites/2/2021/11/lil-nas-x-press-1024x650.jpeg",
        "Daniel Holzfuß",
        "Nicht nur mein Fuß ist aus Holz",
        "11:11"),
    User("https://img1.dreamies.de/img/21/b/p4el6oypvd7.jpg", "NoSack Haare",
        "Open to work", "12:59"),
    User(
        "https://img1.dreamies.de/img/21/b/p4el6oypvd7.jpg",
        "Hendrik HaveAChin",
        "Ich bin so geil, ich könnte den Ball ...",
        "18:20"),
    User("https://img1.dreamies.de/img/21/b/p4el6oypvd7.jpg", "Dani Holzwarth",
        "Am Meisten mag ich an mir meine roten Haare", "01:10"),
  ];
  List<User> _foundUsersList = [];

  @override
  void initState() {
    _foundUsersList = _allUserList;
    super.initState();
  }

  late AppLocalizations appLocale;
  late Size deviceSize;

  @override
  Widget build(BuildContext context) {
    appLocale = AppLocalizations.of(context)!;
    deviceSize = MediaQuery.of(context).size;
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
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _foundUsersList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(_foundUsersList[index].profilePic),
                    ),
                    title: Text(
                      _foundUsersList[index].name,
                    ),
                    subtitle: Text(_foundUsersList[index].lastMessage),
                    trailing: Text(_foundUsersList[index].time),
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
          onChanged: (value) => filterSearchResults(value),
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
            hintText: appLocale.hintTextSearchBarSearchPage,
          ),
        ),
      ),
    );
  }

  filterSearchResults(String text) {
    List<User> filterList = <User>[];
    if (text != null) {
      setState(
        () {
          filterList.addAll(_allUserList
              .where((user) => user.name.toString().contains(text))
              .toList());
          _foundUsersList = filterList;
        },
      );
    } else {
      _foundUsersList = _allUserList;
    }
  }
}

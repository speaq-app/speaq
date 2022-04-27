import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/pages/base/messages/user.dart';
import 'package:frontend/widgets/all_widgets.dart';
import '../../../utils/speaq_styles.dart';

//https://dev.to/iizmotabar/flutter-ui-series-whatsapp-clone-51e1

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final String langKey = "pages.base.messages.";
  String profilePicture =
      "https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg";

  List<User> userList = [
    User(
        "https://www.cleverfiles.com/howto/wp-content/uploads/2018/03/minion.jpg",
        "Sven Gatnar",
        "Ich bin so ein geiler Typ",
        "12:20"),
    User(
        "https://hotdogworld.de/media/image/dd/5f/5f/HZ_TK_500ml_USD_1280x1280.jpg",
        "Alois Heinz",
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
  List<User> _foundedUsers = [];

  @override
  void initState() {
    super.initState();

    setState(() {
      _foundedUsers = userList;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        appBar: SpqAppBar(
          title: const Text(
            "Messages",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          preferredSize: deviceSize,
          centerTitle: true,
          actionList: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.blue,
              iconSize: 25,
              onPressed: () =>
              {
                Navigator.popAndPushNamed(context, "settings"),
              },
            )
          ],
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(profilePicture),
                ));
          }),


        ),
        body: ListView.builder(
          itemCount: _foundedUsers.length, itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: deviceSize.height*0.08,
              width: deviceSize.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: TextField(
                  onChanged: (value) => inputText(value),
                  decoration: InputDecoration(
                    filled: true,
                    //contentPadding: EdgeInsets.symmetric(vertical: 0),
                    prefixIcon:
                    const Icon(Icons.search, color: spqDarkGreyTranslucent),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: BorderSide.none),
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: spqDarkGreyTranslucent,
                    ),
                    hintText: "Search for chats or groups",
                  ),
                ),
              ),
            );
          } else {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userList[index].profilePic),
              ),
              title: Text(userList[index].name,
                style: TextStyle(
                ),
              ),
              subtitle: Text(userList[index].lastMessage),
              trailing: Text(userList[index].time),
            );
          }
        },),
      ),
    );
  }

  inputText(String text) {
    print(text);
  }

  usercomponent({required User user}) {
    return Container(
      child: Row(children: [
        Container(
            width: 60,
            height: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(user.name),
            )),
        SizedBox(width: 10),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(user.name,
              style:
              TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
          SizedBox(
            height: 5,
          ),
          Text(user.lastMessage, style: TextStyle(color: Colors.grey[500])),
        ]),
      ]),
    );
  }
}

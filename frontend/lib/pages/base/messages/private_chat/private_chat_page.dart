import 'package:flutter/material.dart';
import 'package:frontend/pages/base/messages/private_chat/components/body.dart';
import 'package:frontend/widgets/all_widgets.dart';

class ChatMessagesPage extends StatefulWidget {
  const ChatMessagesPage({Key? key}) : super(key: key);

  @override
  State<ChatMessagesPage> createState() => _ChatMessagesPageState();
}

class _ChatMessagesPageState extends State<ChatMessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: const Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const BackButton(),
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/user_2.png"),
          ),
          const SizedBox(width: 20.0 * 0.75),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Kristin Watson",
                style: TextStyle(fontSize: 16),
              ),
              const Text(
                "Active 3m ago",
                style: TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.local_phone),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          onPressed: () {},
        ),
        const SizedBox(width: 20.0 / 2),
      ],
    );
  }
}

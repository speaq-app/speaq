import 'package:flutter/material.dart';
import 'package:frontend/utils/speaq_styles.dart';

class PostContainer extends StatelessWidget {
  final String name;
  final String username;
  final String postMessage;

  const PostContainer({
    Key? key,
    required this.name,
    required this.username,
    required this.postMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage(
                'https://www.jobvector.de/karriere-ratgeber/wp-content/uploads/2021/05/it-security360x240.jpg'),
          ),
          title: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(username,
                        style:
                            const TextStyle(fontSize: 15, color: spqDarkGrey)),
                  ),
                  const Text("12/39/19",
                      style: TextStyle(fontSize: 15, color: spqDarkGrey))
                ],
              )
            ],
          ),
          subtitle: Column(
            children: [
              Text(
                postMessage,
                overflow: TextOverflow.clip,
                style: const TextStyle(color: spqBlack, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Icon(Icons.mic, color: spqDarkGrey),
                  Text("69"),
                  SizedBox(width: 30),
                  Icon(Icons.favorite, color: spqErrorRed),
                  Text("238"),
                  SizedBox(width: 30),
                  Icon(Icons.ios_share, color: spqDarkGrey),
                  SizedBox(width: 30),
                  Icon(Icons.bookmark, color: spqDarkGrey)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

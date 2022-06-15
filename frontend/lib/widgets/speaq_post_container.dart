import 'package:flutter/material.dart';
import 'package:frontend/utils/all_utils.dart';
import 'package:intl/intl.dart';

class PostContainer extends StatelessWidget {
  final String name;
  final String username;
  final DateTime creationTime;

  final int numberOfLikes;
  final int numberOfComments;

  final String postMessage;
  final Widget postImage;
  //final Widget postGif;
  //final Widget postAudio;
  //final Widget postVideo;

  const PostContainer({
    Key? key,
    required this.name,
    required this.username,
    required this.creationTime,
    required this.numberOfLikes,
    required this.numberOfComments,
    this.postMessage = "",
    this.postImage = const SizedBox(height: 0),
    //this.postGif = const SizedBox(height: 0),
    //this.postAudio = const SizedBox(height: 0),
    //this.postVideo = const SizedBox(height: 0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage('https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg'),
          ),
          title: _buildPostTitle(),
          subtitle: _buildContent(),
        ),
      ],
    );
  }

  Widget _buildPostTitle() {
    late DateFormat formatter;
    if (!DateTime.now().isBefore(creationTime.add(const Duration(days: 1)))) {
      formatter = DateFormat('H:m');
    } else if (!DateTime.now().isBefore(creationTime.add(const Duration(days: 365)))) {
      formatter = DateFormat('MM-dd');
    } else {
      formatter = DateFormat('yyyy-MM');
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Text(
                name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "@" + username,
                  style: const TextStyle(fontSize: 15, color: spqDarkGrey),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                formatter.format(creationTime),
                style: const TextStyle(fontSize: 15, color: spqDarkGrey),
                maxLines: 1,
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          postMessage,
          overflow: TextOverflow.clip,
          style: const TextStyle(color: spqBlack, fontSize: 18),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: postImage,
        ),
        //Other Elements
        const SizedBox(height: 5),
        _buildReactionList(),
      ],
    );
  }

  Widget _buildReactionList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.mic, color: spqDarkGrey),
        Text(numberOfComments.toString()),
        const SizedBox(width: 30),
        const Icon(Icons.favorite, color: spqErrorRed),
        Text(numberOfLikes.toString()),
        const SizedBox(width: 30),
        const Icon(Icons.ios_share, color: spqLightGrey),
        const SizedBox(width: 30),
        const Icon(Icons.bookmark, color: spqLightGrey)
      ],
    );
  }
}

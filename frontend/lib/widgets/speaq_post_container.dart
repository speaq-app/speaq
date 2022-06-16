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
    //Fix DateFormat completely
    late String formattedDate;
    final DateTimeRange calculatedDateTime = DateTimeRange(start: creationTime, end: DateTime.now());
    if (calculatedDateTime.duration.inMinutes < 1) {
      String suffix = " Sekunden her";
      formattedDate = calculatedDateTime.duration.inSeconds.toString() + suffix;
    } else if (calculatedDateTime.duration.inHours < 1) {
      String suffix = " Minuten her";
      formattedDate = calculatedDateTime.duration.inMinutes.toString() + suffix;
    } else if (calculatedDateTime.duration.inDays < 1) {
      String suffix = " Stunden her";
      formattedDate = calculatedDateTime.duration.inHours.toString() + suffix;
    } else if (calculatedDateTime.duration.inDays < 7) {
      String suffix = " Tage her";
      formattedDate = calculatedDateTime.duration.inDays.toString() + suffix;
    } else if (calculatedDateTime.duration.inDays < 31) {
      String suffix = " Wochen her";
      formattedDate = (calculatedDateTime.duration.inDays % 7).toString() + suffix;
    } else {
      String prefix = "Am ";
      formattedDate = prefix + calculatedDateTime.duration.inSeconds.toString();
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
            // Expanded(
            //   flex: 3,
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 15.0),
            //     child: Text(
            //       "@" + username,
            //       style: const TextStyle(fontSize: 15, color: spqDarkGrey),
            //       maxLines: 1,
            //       overflow: TextOverflow.clip,
            //       softWrap: false,
            //     ),
            //   ),
            // ),
            Expanded(
              flex: 2,
              child: Text(
                formattedDate,
                //formatter.format(creationTime),
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

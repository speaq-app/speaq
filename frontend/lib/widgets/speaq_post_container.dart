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
    AppLocalizations appLocale = AppLocalizations.of(context)!;
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            backgroundImage: NetworkImage('https://unicheck.unicum.de/sites/default/files/artikel/image/informatik-kannst-du-auch-auf-englisch-studieren-gettyimages-rosshelen-uebersichtsbild.jpg'),
          ),
          title: _buildPostTitle(),
          subtitle: _buildContent(appLocale),
        ),
      ],
    );
  }

  Widget _buildPostTitle() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.clip,
                softWrap: false,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  "@" + username,
                  style: const TextStyle(fontSize: 12, color: spqDarkGrey),
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  softWrap: false,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent(AppLocalizations appLocale) {
    final String formattedDate = _formatDate(appLocale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          postMessage,
          overflow: TextOverflow.clip,
          style: const TextStyle(color: spqBlack, fontSize: 15),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: postImage,
        ),
        //Other Elements like Gif etc.
        const SizedBox(height: 5),
        _buildReactionList(),
        const SizedBox(height: 10),
        Text(
          formattedDate,
          style: const TextStyle(fontSize: 12, color: spqDarkGrey),
          maxLines: 1,
          overflow: TextOverflow.clip,
          softWrap: false,
        ),
        const SizedBox(height: 5),
        const Divider(height: 2)
      ],
    );
  }

  String _formatDate(AppLocalizations appLocale) {
    final DateTimeRange calculatedDateTime = DateTimeRange(start: creationTime, end: DateTime.now());
    if (calculatedDateTime.duration.inMinutes < 1) {
      return calculatedDateTime.duration.inSeconds.toString() + appLocale.secondsAgo;
    }
    if (calculatedDateTime.duration.inMinutes < 2) {
      return calculatedDateTime.duration.inMinutes.toString() + appLocale.minuteAgo;
    }

    if (calculatedDateTime.duration.inHours < 1) {
      return calculatedDateTime.duration.inMinutes.toString() + appLocale.minutesAgo;
    }

    if (calculatedDateTime.duration.inHours < 2) {
      return calculatedDateTime.duration.inHours.toString() + appLocale.hourAgo;
    }

    if (calculatedDateTime.duration.inDays < 1) {
      return calculatedDateTime.duration.inHours.toString() + appLocale.hoursAgo;
    }

    if (calculatedDateTime.duration.inDays < 2) {
      return calculatedDateTime.duration.inDays.toString() + appLocale.dayAgo;
    }

    if (calculatedDateTime.duration.inDays < 7) {
      return calculatedDateTime.duration.inDays.toString() + appLocale.daysAgo;
    }

    if (calculatedDateTime.duration.inDays < 14) {
      return (calculatedDateTime.duration.inDays ~/ 7).toString() + appLocale.weekAgo;
    }

    if (calculatedDateTime.duration.inDays < 31) {
      return (calculatedDateTime.duration.inDays ~/ 7).toString() + appLocale.weeksAgo;
    }

    final DateFormat formatter = DateFormat("d. MMMM y");
    return appLocale.dateAt + formatter.format(creationTime);
  }

  Widget _buildReactionList() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildIconWithText(
              const Icon(Icons.mic, color: spqDarkGrey, size: 20),
              numberOfComments.toString(),
            ),
            _buildIconWithText(
              const Icon(Icons.favorite, color: spqErrorRed, size: 20),
              numberOfLikes.toString(),
            ),
            const Icon(Icons.ios_share, color: spqLightGrey, size: 20),
            const Icon(Icons.bookmark, color: spqLightGrey, size: 20)
          ],
        ),
      ],
    );
  }

  Widget _buildIconWithText(Icon icon, String text) {
    return Text.rich(
      TextSpan(
        children: [
          WidgetSpan(child: icon),
          TextSpan(text: text),
        ],
      ),
    );
  }
}

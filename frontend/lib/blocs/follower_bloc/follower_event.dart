part of 'follower_bloc.dart';

@immutable
abstract class FollowerEvent {}

class LoadFollowerIDs extends FollowerEvent {
  final int userId;

  LoadFollowerIDs({
    required this.userId,
  });
}

class LoadFollower extends FollowerEvent {
  final List<int> followerIDs;
  final List<int> followingIDs;

  LoadFollower({
    required this.followerIDs,
    required this.followingIDs,
  });
}

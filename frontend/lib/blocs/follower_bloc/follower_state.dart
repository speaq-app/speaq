part of 'follower_bloc.dart';

@immutable
abstract class FollowerState {}

class FollowerInitial extends FollowerState {}

class FollowerIDsLoading extends FollowerState {}

class FollowerIDsLoaded extends FollowerState {
  final List<int> followerIDs;
  final List<int> followingIDs;

  FollowerIDsLoaded({required this.followerIDs, required this.followingIDs});
}

class FollowerLoading extends FollowerState {}

class FollowerLoaded extends FollowerState {
  final List<FollowUser> follower;
  final List<FollowUser> following;

  FollowerLoaded({required this.follower, required this.following});
}

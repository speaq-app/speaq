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
  final List<CondensedUser> follower;
  final List<CondensedUser> following;

  FollowerLoaded({required this.follower, required this.following});
}

class FollowUnfollowLoading extends FollowerState {}

class FollowUnfollowLoaded extends FollowerState {
  final bool isFollowing;

  FollowUnfollowLoaded({required this.isFollowing});
}

class CheckIfFollowingLoaded extends FollowerState {
  final bool isFollowing;

  CheckIfFollowingLoaded({required this.isFollowing});
}


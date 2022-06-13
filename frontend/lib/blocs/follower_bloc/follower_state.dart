part of 'follower_bloc.dart';

@immutable
abstract class FollowerState {}

class FollowerInitial extends FollowerState {}

class FollowerLoading extends FollowerState {}

class FollowerLoaded extends FollowerState {
  final List<int> follower;
  final List<int> following;

  FollowerLoaded( {required this.follower, required this.following});
}

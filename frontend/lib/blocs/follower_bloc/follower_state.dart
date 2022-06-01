part of 'follower_bloc.dart';

@immutable
abstract class FollowerState {}

class FollowerInitial extends FollowerState {}

class FollowerLoading extends FollowerState {}

class FollowerLoaded extends FollowerState {
  final int follower;

  FollowerLoaded({required this.follower});
}

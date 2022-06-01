part of 'follower_bloc.dart';

@immutable
abstract class FollowerEvent {}

class LoadFollower extends FollowerEvent {
  final int userId;

  LoadFollower({
    required this.userId,
  });
}

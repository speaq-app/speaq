part of 'search_bloc.dart';

@immutable
abstract class SearchState {}

class SearchInitial extends SearchState {}

class SearchStarted extends SearchState {}

class RequestSend extends SearchState {}

class ResultsReceived extends SearchState {
  final List<CondensedUser> users;

  ResultsReceived({required this.users});
}

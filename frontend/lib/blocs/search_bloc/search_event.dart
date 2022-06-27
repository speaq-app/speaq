part of 'search_bloc.dart';

@immutable
abstract class SearchEvent {}

class StartSearch extends SearchEvent {
  final String term;

  StartSearch({
    required this.term,
  });
}

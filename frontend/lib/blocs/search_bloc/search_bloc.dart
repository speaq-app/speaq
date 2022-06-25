import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/user_service.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserService _userService = GRPCUserService("10.0.2.2", port: 8080);

  SearchBloc() : super(SearchInitial()) {
    on<StartSearch>(_onStartSearch);
  }

  Future<void> _onStartSearch(
      StartSearch event, Emitter<SearchState> emit) async {
    emit(SearchStarted());

    emit(RequestSend());

    List<CondensedUser> matchingUsers =
        await _userService.userByUsername(searchTerm: event.username);

    emit(ResultsReceived(users: matchingUsers));
  }
}

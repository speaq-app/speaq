import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/grpc/grpc_user_service.dart';
import 'package:frontend/api/grpc/protos/user.pbgrpc.dart';
import 'package:frontend/api/user_service.dart';
import 'package:frontend/utils/backend_utils.dart';
import 'package:meta/meta.dart';

part 'search_event.dart';

part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final UserService _userService =
      GRPCUserService(BackendUtils.createClientChannel());

  SearchBloc() : super(SearchInitial()) {
    on<StartSearch>(_onStartSearch);
  }

  Future<void> _onStartSearch(
      StartSearch event, Emitter<SearchState> emit) async {
    emit(SearchStarted());

    emit(RequestSend());

    List<CondensedUser> matchingUsers = event.term.isNotEmpty
        ? await _userService.searchUser(searchTerm: event.term.trim())
        : [];

    emit(ResultsReceived(users: matchingUsers));
  }
}

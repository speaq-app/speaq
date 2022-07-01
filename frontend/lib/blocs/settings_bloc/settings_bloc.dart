import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/api/grpc/grpc_settings_service.dart';
import 'package:frontend/api/settings_service.dart';
import 'package:frontend/utils/backend_utils.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService =
      GRPCSettingsService(BackendUtils.createClientChannel());

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadImprintURL>(_onLoadImprintURL);
  }

  void _onLoadImprintURL(
      LoadImprintURL event, Emitter<SettingsState> emit) async {
    emit(LoadingImprintURL());

    var url = await _settingsService.getImprintURL();
    emit(ImprintURLLoaded(url));
  }
}

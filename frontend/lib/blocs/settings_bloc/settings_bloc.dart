import 'package:bloc/bloc.dart';
import 'package:frontend/api/grpc/grpc_settings_service.dart';
import 'package:frontend/api/settings_service.dart';
import 'package:meta/meta.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsService _settingsService =
      GRPCSettingsService("10.0.2.2", port: 8080);

  SettingsBloc() : super(SettingsInitial()) {
    on<LoadImprintURL>(_onLoadImprintURL);
  }

  void _onLoadImprintURL(
    LoadImprintURL event,
    Emitter<SettingsState> emit,
  ) async {
    emit(LoadingImprintURL());
    await Future.delayed(const Duration(seconds: 2)); //removeable

    var url = await _settingsService.getImprintURL();
    emit(ImprintURLLoaded(url));
  }
}

part of 'settings_bloc.dart';

@immutable
abstract class SettingsState {}

class SettingsInitial extends SettingsState {}

class LoadingImprintURL extends SettingsState {}

class ImprintURLLoaded extends SettingsState {
  final Uri imprintURL;

  ImprintURLLoaded(this.imprintURL);
}

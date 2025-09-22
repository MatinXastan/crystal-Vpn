part of 'config_list_bloc.dart';

@immutable
sealed class ConfigListEvent {}

class StartCheckingStatusEvent extends ConfigListEvent {}

class StartRecivingConfigsEvent extends ConfigListEvent {}

class StartTestingPingsForAllConfigsEvent extends ConfigListEvent {
  final List<ConfigModel> configs;
  StartTestingPingsForAllConfigsEvent({required this.configs});
}

class StartTestingPingForOneConfigEvent extends ConfigListEvent {}

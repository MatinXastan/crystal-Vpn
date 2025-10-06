part of 'config_list_bloc.dart';

@immutable
sealed class ConfigListState {}

final class ConfigListInitial extends ConfigListState {}

final class StartingTestPingConfingsState extends ConfigListState {
  final List<ConfigModel> configsNotTested;
  final List<ConfigModel> configsTested;
  StartingTestPingConfingsState({
    required this.configsNotTested,
    required this.configsTested,
  });
}

final class TestPingConfingsSuccessState extends ConfigListState {
  final List<ConfigModel> configsTested;
  TestPingConfingsSuccessState({required this.configsTested});
}

final class TestPingConfingsErrorState extends ConfigListState {}

//
final class StartingTestPingOneConfigState extends ConfigListState {}

final class TestPingOneConfigSuccessState extends ConfigListState {}

final class TestPingOneConfigErrorState extends ConfigListState {}

//completed
final class StartRecivingConfigsState extends ConfigListState {}

// تکمیل شد
// ignore: must_be_immutable
final class RecivingConfigsSuccessState extends ConfigListState {
  List<String> vless;
  List<String> vmess;
  List<String> trojan;
  List<String> shadowSocks;
  List<String> tuic;

  List<String> unknownProtocol;

  RecivingConfigsSuccessState({
    required this.vless,
    required this.vmess,
    required this.trojan,
    required this.shadowSocks,
    required this.tuic,
    required this.unknownProtocol,
  });
}

// تکمیل شد
final class RecivingConfigsErrorState extends ConfigListState {
  final String error;
  RecivingConfigsErrorState({required this.error});
}

// تکمیل شد
final class EmptyConfigState extends ConfigListState {}

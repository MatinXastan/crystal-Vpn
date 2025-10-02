part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class ConfigsAreEmptyState extends HomeState {}

final class ConnectingAdvancedAutoConfigState extends HomeState {}

final class ConnectingSelectedConfigState extends HomeState {}

final class ConnectingAutoManualConfigState extends HomeState {}
 

/*
final class RecivingConfigAdvancedAutoErrorState extends HomeState {}

final class RecivingConfigAdvancedAutoSuccessState extends HomeState {}
 */
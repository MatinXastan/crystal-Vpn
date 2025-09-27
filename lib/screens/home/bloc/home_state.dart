part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class StartChanginstatusState extends HomeState {
  final int status;

  StartChanginstatusState({required this.status});
}

final class StartRecivingConfigAdvancedAutoState extends HomeState {}

final class RecivingConfigAdvancedAutoErrorState extends HomeState {}

final class RecivingConfigAdvancedAutoSuccessState extends HomeState {}

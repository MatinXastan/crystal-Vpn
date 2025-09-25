part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class ConnectToVpnEvent extends HomeEvent {
  final ConnectionMode selectedMode;

  ConnectToVpnEvent({required this.selectedMode});
}

class DisconnectFromVpnEvent extends HomeEvent {}

class CheckLocationVpnEvent extends HomeEvent {}

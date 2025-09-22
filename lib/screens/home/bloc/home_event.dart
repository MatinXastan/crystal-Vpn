part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class ConnectToVpnEvent extends HomeEvent {}

class DisconnectFromVpnEvent extends HomeEvent {}

class CheckLocationVpnEvent extends HomeEvent {}

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<ConnectToVpnEvent>((event, emit) {});

    on<DisconnectFromVpnEvent>((event, emit) {});
    on<CheckLocationVpnEvent>((event, emit) {});
  }
}

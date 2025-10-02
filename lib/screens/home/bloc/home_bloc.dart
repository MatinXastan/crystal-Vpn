import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vpn/configurations/validators.dart';
import 'package:vpn/data/model/config_advanced_model.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/screens/home/custom_segmented_button.dart';
import 'package:vpn/screens/home/home_screen.dart';
import 'package:vpn/services/v2ray_services.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final V2rayService _v2rayService;
  final IReciveConfigsRepo reciveConfigsRepo;
  final ConfigAdvancedModel advancedAutoConfigs;
  HomeBloc({
    required this.advancedAutoConfigs, // پارامتر اختیاری
    required V2rayService v2rayService,
    required this.reciveConfigsRepo,
  }) : _v2rayService = v2rayService,
       super(HomeInitial()) {
    on<ConnectToVpnEvent>((event, emit) async {
      /* 
      if (event.selectedMode == ConnectionMode.advancedAuto) {
        emit(ConnectingAdvancedAutoConfigState());
        _v2rayService.initializeConfigs(advancedAutoConfigs.configs);
        await _v2rayService.connectAuto();
        //emit(RecivingConfigAdvancedAutoSuccessState());
      } else if (event.selectedMode == ConnectionMode.manual) {
        if (_v2rayService.displayConfigs.isNotEmpty) {
          if (_v2rayService.selectedConfig == null) {
            emit(ConnectingSelectedConfigState());
            await _v2rayService.connectAuto();
          } else {
            emit(ConnectingAutoManualConfigState());
            await _v2rayService.connect(_v2rayService.selectedConfig!);
          }
        } else {
          // باید به صفحه کانفیگ لیست اسکرین بره
          emit(ConfigsAreEmptyState());
        }
      } */
    });
    //on<DisconnectFromVpnEvent>((event, emit) async {});
    //on<CheckLocationVpnEvent>((event, emit) async {});
  }
}

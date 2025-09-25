import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vpn/configurations/validators.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/screens/widgets/custom_segmented_button.dart';
import 'package:vpn/services/v2ray_services.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final V2rayService _v2rayService;
  final IReciveConfigsRepo reciveConfigsRepo;
  HomeBloc(this.reciveConfigsRepo, {required V2rayService v2rayService})
    : _v2rayService = v2rayService,
      super(HomeInitial()) {
    on<ConnectToVpnEvent>((event, emit) async {
      /* if (_v2rayService.selectedConfig == null) {
        if (_v2rayService.displayConfigs.length > 1) {
          _v2rayService.connectAuto();
        } else {
         
          // این کد می‌گوید: "متد initializeConfigs را با این لیست به عنوان ورودی، اجرا کن"
          _v2rayService.initializeConfigs(convertConfigToModel(configs)); 
        }
      } */

      if (event.selectedMode == ConnectionMode.advancedAuto) {}
    });
  }
}

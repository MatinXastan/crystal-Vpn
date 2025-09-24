import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:vpn/configurations/validators.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
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
      if (_v2rayService.selectedConfig == null) {
        if (_v2rayService.displayConfigs.length > 1) {
          _v2rayService.connectAuto();
        } else {
          final response = await reciveConfigsRepo.futureConfigs(
            'v2ray_configs.txt',
          );
          //TODO: بهتره که این بخش لینک مخصوص داشته باشه و  در اول اجرای برنامه مقدار دهی بشه
          final configs = separateconfigsVmess(response);
          // این کد می‌گوید: "متد initializeConfigs را با این لیست به عنوان ورودی، اجرا کن"
          _v2rayService.initializeConfigs(convertConfigToModel(configs));
        }
      }
    });
  }

  List<String> separateconfigsVmess(List<String> configs) {
    // ... این متد بدون تغییر باقی می‌ماند ...
    List<String> vless = [];
    List<String> vmess = [];
    List<String> trojan = [];
    List<String> shadowSocks = [];
    List<String> tuic = [];
    List<String> unknownProtocol = [];

    for (var config in configs) {
      final protocol = Validators.getProtocolType(config);
      switch (protocol) {
        case 'VLESS':
          vless.add(config);
          break;
        case 'VMess':
          vmess.add(config);
          break;
        case 'Trojan':
          trojan.add(config);
          break;
        case 'ShadowSocks':
          shadowSocks.add(config);
          break;
        case 'Tuic':
          tuic.add(config);
          break;
        default:
          unknownProtocol.add(config);
          break;
      }
    }

    return vmess;
  }

  List<ConfigModel> convertConfigToModel(List<String> configs) {
    List<ConfigModel> configModels = [];
    for (var config in configs) {
      configModels.add(ConfigModel(config: config, delay: 0));
    }
    return configModels;
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/data_vpn_repo.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/screens/configVpnScreen/bloc/config_list_bloc.dart';
import 'package:vpn/screens/configVpnScreen/protocol_screen.dart';

class TestWidget extends StatelessWidget {
  const TestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return BlocProvider(
                      create: (context) => ConfigListBloc(
                        dataVpnRepo: vpnRepository,
                        reciveConfigsRepo: reciveConfigsRepo,
                      ),
                      child: ProtocolScreen(
                        configs: convertConfigToModel(configs),
                        protocolType: 'dsds',
                      ),
                    );
                  },
                ),
              );
            },
            child: Text('go to protocol screen'),
          ),
        ),
      ),
    );
  }
}

List<String> configs = [
  'vless://c99f45df-5daf-4610-81ea-b9b4ea7258f4@91.99.217.44:443?encryption=none&security=none&type=xhttp&path=%2Frf&mode=stream-one#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40vmesskhodam%20%5B5%5D',
  'vless://4ecaf621-8a2c-4ec7-8308-43169f832a8d@188.245.119.21:26110?encryption=none&security=none&type=tcp&headerType=none#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40v2rayng3%20%5B6%5D',
  'vless://c3001ca6-96f6-4c60-833c-4495c0c6951e@54.36.114.253:25369?encryption=none&security=none&type=grpc&authority=&serviceName=ZEDMODEON-ZEDMODEON-ZEDMODEON-bia-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON&mode=gun#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40v2rayopen%20%5B5%5D',
];

List<ConfigModel> convertConfigToModel(List<String> configs) {
  List<ConfigModel> configModels = [];
  for (var config in configs) {
    configModels.add(ConfigModel(config: config, delay: 0));
  }
  return configModels;
}

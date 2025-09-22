import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/data_vpn_repo.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/configVpnScreen/bloc/config_list_bloc.dart';
import 'package:vpn/screens/configVpnScreen/empty_config_screen.dart';
import 'package:vpn/screens/configVpnScreen/protocol_screen.dart';
import 'package:vpn/screens/widgets/connection_button.dart';
import 'package:vpn/screens/widgets/glass_box.dart';
import 'package:vpn/screens/widgets/aurora_border.dart';

class ListOfConfigsScreen extends StatefulWidget {
  const ListOfConfigsScreen({super.key});

  @override
  State<ListOfConfigsScreen> createState() => _ListOfConfigsScreenState();
}

class _ListOfConfigsScreenState extends State<ListOfConfigsScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: BlocProvider(
          create: (context) {
            final bloc = ConfigListBloc(
              dataVpnRepo: vpnRepository,
              reciveConfigsRepo: reciveConfigsRepo,
            );
            bloc.add(StartCheckingStatusEvent());
            return bloc;
          },
          child: Stack(
            children: [
              Positioned.fill(
                child: Assets.images.backgrounds.greenBackground.image(
                  fit: BoxFit.cover,
                ),
              ),
              BlocConsumer<ConfigListBloc, ConfigListState>(
                builder: (context, state) {
                  if (state is EmptyConfigState) {
                    return Center(
                      child: EmptyConfigScreen(
                        ontap: () {
                          context.read<ConfigListBloc>().add(
                            StartRecivingConfigsEvent(),
                          );
                        },
                      ),
                    );
                  } else if (state is StartRecivingConfigsState) {
                    //TODO: یادم باشه داخل سایت لوتی یه انیمیشن خوب برا اینجا بیارم
                    return Center(child: Text('در حال دریافت کانفیگ‌ها...'));
                  } else if (state is RecivingConfigsSuccessState) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 32,
                                  right: 32,
                                  top: 32,
                                  bottom: 12,
                                ),
                                child: GlassBox(
                                  width: size.width / 12,
                                  height: size.height / 2.7,
                                  child: ConfigProtocolCard(
                                    protocolType: 'VLESS',
                                    count: state.vless.length,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ProtocolScreen(
                                            configs: convertConfigToModel(
                                              state.vless,
                                            ),
                                            protocolType: "VLESS",
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 32,
                                  right: 32,
                                  top: 32,
                                  bottom: 12,
                                ),
                                child: GlassBox(
                                  width: size.width / 12,
                                  height: size.height / 2.7,
                                  child: ConfigProtocolCard(
                                    protocolType: 'VMESS',
                                    count: state.vmess.length,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (c) => BlocProvider.value(
                                            value: context
                                                .read<ConfigListBloc>(),
                                            child: ProtocolScreen(
                                              configs: convertConfigToModel(
                                                state.vmess,
                                              ),
                                              protocolType: "VMESS",
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 32,
                                  right: 32,
                                  top: 32,
                                  bottom: 12,
                                ),
                                child: GlassBox(
                                  width: size.width / 12,
                                  height: size.height / 2.7,
                                  child: ConfigProtocolCard(
                                    protocolType: 'TROJAN',
                                    count: state.trojan.length,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: context
                                                .read<ConfigListBloc>(),
                                            child: ProtocolScreen(
                                              configs: convertConfigToModel(
                                                state.trojan,
                                              ),
                                              protocolType: "TROJAN",
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 32,
                                  right: 32,
                                  top: 32,
                                  bottom: 12,
                                ),
                                child: GlassBox(
                                  width: size.width / 12,
                                  height: size.height / 2.7,
                                  child: ConfigProtocolCard(
                                    protocolType: 'SHADOWSOCKS',
                                    count: state.shadowSocks.length,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: context
                                                .read<ConfigListBloc>(),
                                            child: ProtocolScreen(
                                              configs: convertConfigToModel(
                                                state.shadowSocks,
                                              ),
                                              protocolType: "SHADOWSOCKS",
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 32,
                                  right: 32,
                                  top: 32,
                                  bottom: size.height / 7.5,
                                ),
                                child: GlassBox(
                                  width: size.width / 12,
                                  height: size.height / 2.7,
                                  child: ConfigProtocolCard(
                                    protocolType: 'TUIC',
                                    count: state.tuic.length,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: context
                                                .read<ConfigListBloc>(),
                                            child: ProtocolScreen(
                                              configs: convertConfigToModel(
                                                state.tuic,
                                              ),
                                              protocolType: "TUIC",
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is RecivingConfigsErrorState) {
                    return Center(child: Text('خطا: ${state.error}'));
                  }
                  return const SizedBox();
                },
                listener: (BuildContext context, ConfigListState state) {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<ConfigModel> convertConfigToModel(List<String> configs) {
    List<ConfigModel> configModels = [];
    for (var config in configs) {
      configModels.add(ConfigModel(config: config, delay: 0));
    }
    return configModels;
  }
}

class ConfigProtocolCard extends StatelessWidget {
  final String protocolType;
  final int count;
  final Function() onTap;

  const ConfigProtocolCard({
    super.key,
    required this.protocolType,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                color: const Color.fromARGB(255, 20, 255, 200),
                size: 85,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(protocolType, style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Divider(color: Colors.blueGrey),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 24, right: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(Icons.format_list_bulleted_rounded, size: 28),
                ),
                SizedBox(width: 4),
                Expanded(
                  child: Text('Count: $count', style: TextStyle(fontSize: 22)),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'All Configs',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decorationColor: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

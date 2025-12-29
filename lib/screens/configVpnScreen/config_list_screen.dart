import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/l10n/app_localizations.dart';
import 'package:vpn/screens/configVpnScreen/bloc/config_list_bloc.dart';
import 'package:vpn/screens/configVpnScreen/empty_config_screen.dart';
import 'package:vpn/screens/configVpnScreen/error_config_screen.dart';
import 'package:vpn/screens/configVpnScreen/protocol_screen.dart';
import 'package:vpn/screens/widgets/glass_box.dart';

class ListOfConfigsScreen extends StatefulWidget {
  const ListOfConfigsScreen({super.key});

  @override
  State<ListOfConfigsScreen> createState() => _ListOfConfigsScreenState();
}

class _ListOfConfigsScreenState extends State<ListOfConfigsScreen> {
  Timer? _autoClickTimer;
  Future<void> _startTimer(state) async {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    // 1. نمایش اسنک‌بار و ذخیره ارجاع به آن
    final snackBarController = ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(appLocalizations.autoRedirectMsg),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // 2. صبر کردن تا زمانی که اسنک‌بار بسته شود
    await snackBarController.closed;

    _autoClickTimer = Timer(const Duration(seconds: 10), () async {
      if (mounted) {
        // 3. چک کردن مجدد mounted قبل از ناویگیشن (امنیت کد)

        // 4. رفتن به صفحه بعد
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProtocolScreen(
              configs: convertConfigToModel(state.vless),
              protocolType: "VLESS",
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _autoClickTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: BlocProvider(
          create: (context) {
            final bloc = ConfigListBloc(reciveConfigsRepo: reciveConfigsRepo);
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
                    return Center(
                      child: Lottie.asset(Assets.images.lottiefiles.loading),
                    );
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
                    return Center(
                      child: ErrorConfigScreen(
                        onRetry: () {
                          context.read<ConfigListBloc>().add(
                            StartRecivingConfigsEvent(),
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox();
                },
                listener: (BuildContext context, ConfigListState state) {
                  if (state is RecivingConfigsSuccessState) {
                    _startTimer(state);
                  }
                },
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.security,
                  color: const Color.fromARGB(255, 2, 255, 196),
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
                    child: Text(
                      '${appLocalizations.countLabel}$count',
                      style: TextStyle(fontSize: 22),
                    ),
                  ),
                  Text(
                    appLocalizations.allConfigs,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decorationColor: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

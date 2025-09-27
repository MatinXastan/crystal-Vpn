import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:provider/provider.dart';
import 'package:vpn/data/model/config_advanced_model.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/home/bloc/home_bloc.dart';
import 'package:vpn/screens/home/connection_button.dart';
import 'package:vpn/screens/home/custom_segmented_button.dart';
import 'package:vpn/services/v2ray_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late V2rayService v2rayService;
  late ConfigAdvancedModel advancedAutoConfigs;
  late ReciveConfigsRepo reciveConfigsRepository; // Define repo instance
  String statuseConnect = "DISCONNECTED";
  @override
  void initState() {
    super.initState();
    // It's generally safer to access providers in didChangeDependencies or build,
    // but read() in initState is acceptable.
    v2rayService = context.read<V2rayService>();
    reciveConfigsRepository = reciveConfigsRepo;
    advancedAutoConfigs = context
        .read<ReciveConfigsRepo>()
        .configsAdvancedAutoNotifier
        .value;
    statuseConnect = context.read<V2rayService>().statuseVpn;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(
        v2rayService: v2rayService,
        reciveConfigsRepo: reciveConfigsRepository,
        advancedAutoConfigs:
            advancedAutoConfigs, // Use the instance read in initState
      ),

      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: Assets.images.background.image(fit: BoxFit.cover),
              ),
              Center(child: ConnectButton(statusVpn: statuseConnect)),
              const Positioned(right: 12, top: 12, child: MySegmentedButton()),
            ],
          ),
        ),
      ),
    );
  }
}

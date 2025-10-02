import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vpn/data/model/config_advanced_model.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/home/bloc/home_bloc.dart';
import 'package:vpn/screens/home/connection_button.dart';
import 'package:vpn/screens/home/custom_segmented_button.dart';
import 'package:vpn/screens/widgets/glass_box.dart';
import 'package:vpn/services/nav_provider.dart';
import 'package:vpn/services/v2ray_services.dart';

enum ConnectionMode { manual, advancedAuto }

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
  ConnectionMode currentMode = ConnectionMode.advancedAuto;
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
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.background.image(fit: BoxFit.cover),
            ),
            Center(
              child: Consumer<V2rayService>(
                builder: (context, value, child) => Column(
                  spacing: 24,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ConnectButton(
                      status: value.statusConnection,
                      connectionMode: currentMode,
                    ),
                    GlassBox(
                      width: size.width / 1.1,
                      height: size.height / 4,
                      child: Row(),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              right: 12,
              top: 12,
              child: MySegmentedButton(
                onModeChanged: (value) {
                  setState(() {
                    currentMode = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

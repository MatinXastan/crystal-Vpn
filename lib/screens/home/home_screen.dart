import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/home/bloc/home_bloc.dart';
import 'package:vpn/screens/widgets/connection_button.dart';
import 'package:vpn/screens/widgets/custom_segmented_button.dart';
import 'package:vpn/services/v2ray_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late V2rayService v2rayService;
  late List<ConfigModel> advancedAutoConfigs;
  late ReciveConfigsRepo reciveConfigsRepo; // Define repo instance

  @override
  void initState() {
    super.initState();
    // It's generally safer to access providers in didChangeDependencies or build,
    // but read() in initState is acceptable.
    v2rayService = context.read<V2rayService>();
    reciveConfigsRepo = context
        .read<ReciveConfigsRepo>(); // Read the repo from provider
    advancedAutoConfigs = reciveConfigsRepo.configsNotifier.value;

    debugPrint(advancedAutoConfigs.toList().toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        // FIX: Correctly pass the repository to the Bloc constructor.
        // Assuming your HomeBloc constructor is:
        // HomeBloc({required this.v2rayService, required this.reciveConfigsRepo})
        return HomeBloc(
          v2rayService: v2rayService,
          reciveConfigsRepo, // Use the instance read in initState
        );
      },
      child: SafeArea(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(
                child: Assets.images.background.image(fit: BoxFit.cover),
              ),
              Center(child: ConnectButton()),
              const Positioned(right: 12, top: 12, child: MySegmentedButton()),
            ],
          ),
        ),
      ),
    );
  }
}

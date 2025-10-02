import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/vpn_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/services/nav_provider.dart';
import 'package:vpn/services/v2ray_services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final directory = await getApplicationSupportDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(VpnModelAdapter());
  Hive.registerAdapter(ConfigTypeAdapter());
  await Hive.openBox<VpnModel>(Conf.configBox);

  await reciveConfigsRepo.reciveConfigAdvancedAuto();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => V2rayService()),
        // FIX: Provide the ReciveConfigsRepo instance itself, not just its notifier.
        Provider<ReciveConfigsRepo>(create: (context) => reciveConfigsRepo),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainScreen(),
    );
  }
}

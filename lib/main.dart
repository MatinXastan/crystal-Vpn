import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/vpn_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/screens/home/home_screen.dart';
import 'package:vpn/main_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:vpn/services/nav_provider.dart';
import 'package:vpn/services/v2ray_services.dart';
import 'package:vpn/test1.dart';
import 'package:vpn/test_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final directory = await getApplicationSupportDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(VpnModelAdapter());
  Hive.registerAdapter(ConfigTypeAdapter());
  await Hive.openBox<VpnModel>(Conf.configBox);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => V2rayService()),
        ChangeNotifierProvider(
          create: (context) => NavigationProvider(), // کلاس دوم
        ),
        // می‌تونی هر تعداد ChangeNotifierProvider دیگه هم اضافه کنی
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/config_advanced_model.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/gen/assets.gen.dart';
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
  //late V2rayService v2rayService;
  //late ConfigAdvancedModel advancedAutoConfigs;
  //late ReciveConfigsRepo reciveConfigsRepository; // Define repo instance
  String statuseConnect = "DISCONNECTED";
  //ConnectionMode currentMode = ConnectionMode.advancedAuto;
  @override
  void initState() {
    super.initState();

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
                builder: (context, service, child) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 28),
                    GlassBox(
                      width: size.width / 1.1,
                      height: size.height / 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("selected server"),
                            SizedBox(height: 8),
                            Container(
                              width: size.width / 1.1,
                              height: size.height / 16,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // گردی گوشه‌ها
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                      0.2,
                                    ), // رنگ سایه
                                    spreadRadius: 2, // پخش شدن سایه
                                    blurRadius: 6, // میزان محو بودن
                                    offset: Offset(2, 3), // جابجایی سایه (x, y)
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // گروه اول: آیکون و متن کنار هم
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.arrow_drop_down,
                                          color:
                                              service.v2rayState ==
                                                  Conf.connectStatus
                                              ? Colors.green
                                              : Colors.blue,
                                        ),
                                        SizedBox(width: 8),
                                        Flexible(
                                          child: Text(
                                            service.selectedRemark ??
                                                "select A config",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // ویجت سوم در انتها
                                    Icon(
                                      Icons.circle,
                                      color:
                                          service.v2rayState ==
                                              Conf.connectStatus
                                          ? Colors.green
                                          : Colors.blue,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 32),
                    ConnectButton(status: service.statusConnection),
                    SizedBox(height: 32),
                    GlassBox(
                      width: size.width / 1.1,
                      height: size.height / 3.5,
                      child: Row(),
                    ),
                    Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),

            /*  Positioned(
              right: 12,
              top: 12,
              child: MySegmentedButton(
                onModeChanged: (value) {
                  setState(() {
                    currentMode = value;
                  });
                },
              ),
            ), */
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

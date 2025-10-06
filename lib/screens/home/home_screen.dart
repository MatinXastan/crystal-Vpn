import 'dart:async';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/configurations/validators.dart';
import 'package:vpn/data/model/ip_info_model.dart';
import 'package:vpn/data/repo/ip_info_repo.dart';

import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/home/connection_button.dart';

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
                            GestureDetector(
                              onTap: () {
                                Provider.of<NavigationProvider>(
                                  context,
                                  listen: false,
                                ).changeTab(BtmNavScreenIndex.config);
                              },
                              child: Container(
                                width: size.width / 1.1,
                                height: size.height / 16,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    12,
                                  ), // گردی گوشه‌ها
                                  gradient: LinearGradient(
                                    colors: [
                                      // ignore: deprecated_member_use
                                      Colors.white.withOpacity(0.2),
                                      // ignore: deprecated_member_use
                                      Colors.white.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      // ignore: deprecated_member_use
                                      color: Colors.black.withOpacity(
                                        0.2,
                                      ), // رنگ سایه
                                      spreadRadius: 2, // پخش شدن سایه
                                      blurRadius: 6, // میزان محو بودن
                                      offset: Offset(
                                        2,
                                        3,
                                      ), // جابجایی سایه (x, y)
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                                : Color.fromARGB(
                                                    255,
                                                    12,
                                                    6,
                                                    173,
                                                    // ignore: deprecated_member_use
                                                  ).withOpacity(0.8),
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
                                            : Color.fromARGB(
                                                255,
                                                12,
                                                6,
                                                173,
                                                // ignore: deprecated_member_use
                                              ).withOpacity(0.8),
                                      ),
                                    ],
                                  ),
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
                    Visibility(
                      visible: service.v2rayState == Conf.connectStatus,
                      child: _ConnectionBox(size: size, service: service),
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

  /* void _showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  } */
}

class _ConnectionBox extends StatelessWidget {
  final V2rayService service;
  const _ConnectionBox({required this.size, required this.service});

  final Size size;

  @override
  Widget build(BuildContext context) {
    final protocolType = Validators.getProtocolType(
      service.selectedConfig?.config ?? "connected",
    );
    return GlassBox(
      width: size.width / 1.1,
      height: size.height / 3.5,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Connection status',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Icon(
                    Icons.circle,
                    color: service.v2rayState == Conf.connectStatus
                        ? Colors.green
                        : Colors.grey,
                  ),
                ],
              ),
              SizedBox(height: 8),
              TimerConnect(service: service),
              SizedBox(height: 4),
              Divider(color: Colors.grey),
              CurrentLocation(service: service),
              SizedBox(height: 4),
              Divider(color: Colors.grey),

              Container(
                alignment: Alignment.center,
                width: size.width / 1.55,
                height: size.height / 14,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  color: const Color.fromARGB(255, 49, 203, 82),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check),
                    SizedBox(width: 4),
                    Text(
                      "Protocol: $protocolType",
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrentLocation extends StatefulWidget {
  final V2rayService service;
  const CurrentLocation({super.key, required this.service});

  @override
  State<CurrentLocation> createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  IpInfoModel? _ipInfo;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    // اگر قصد دارید همیشه موقع ساخت ویجت لوکیشن را بگیرید:
    _maybeFetchLocation();

    // اگر می‌خواهید فقط زمانی که v2rayState تغییر می‌کند عمل کنید،
    // باید لیسنری روی وضعیت سرویس اضافه کنید یا از parent برای بازسازی ویجت استفاده کنید.
  }

  void _maybeFetchLocation() {
    if (widget.service.v2rayState == Conf.connectStatus) {
      Future.delayed(Duration(seconds: 3)).then((value) {
        _fetchLocation();
      });
    }
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ipInfo = await ipInfoRepo
          .getIpInfo(); // ipInfoRepo از جایی در دسترس فرض شده
      if (!mounted) return;
      setState(() {
        _ipInfo = ipInfo;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Unable to fetch location';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget rightChild;

    if (_loading) {
      rightChild = const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (_error != null) {
      rightChild = Text('Error', style: TextStyle(color: Colors.red));
    } else if (_ipInfo != null) {
      rightChild = Text(
        '${_ipInfo!.countryCode!} ${_ipInfo!.countryName!}',
        /* _ipInfo!.countryCode!+_ipInfo!.countryName! */
        style: const TextStyle(fontSize: 18, color: Colors.green),
      );
    } else {
      rightChild = const Text(
        'Unknown',
        style: TextStyle(color: Colors.white, fontSize: 18),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: const [
            Icon(Icons.language, color: Colors.grey),
            SizedBox(width: 4),
            Text(
              'Location',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
        Row(
          children: [
            rightChild,
            Visibility(visible: _error != null, child: SizedBox(width: 8)),

            Visibility(
              visible: _error != null,
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white),
                onPressed: _fetchLocation,
                tooltip: 'Refresh location',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TimerConnect extends StatefulWidget {
  final V2rayService service;
  const TimerConnect({super.key, required this.service});

  @override
  State<TimerConnect> createState() => _TimerConnectState();
}

class _TimerConnectState extends State<TimerConnect> {
  late Stopwatch _stopwatch;
  Timer? _ticker;
  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();

    if (widget.service.v2rayState == Conf.connectStatus) {
      _start();
    } else {
      _stop();
      _reset();
    }
  }

  void _start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _ticker = Timer.periodic(Duration(seconds: 1), (_) => setState(() {}));
    }
  }

  void _stop() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _ticker?.cancel();
      setState(() {}); // یک بار برای به‌روزرسانی نهایی
    }
  }

  void _reset() {
    _stopwatch.reset();
    _ticker?.cancel();
    setState(() {});
  }

  String _formatElapsed(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final hours = two(d.inHours);
    final minutes = two(d.inMinutes.remainder(60));
    final seconds = two(d.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.timer, color: Colors.grey),
            SizedBox(width: 4),
            Text('Up time', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
        Text(
          _formatElapsed(elapsed),
          style: TextStyle(
            color: Colors.green,
            fontSize: 18,
            fontFeatures: [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}

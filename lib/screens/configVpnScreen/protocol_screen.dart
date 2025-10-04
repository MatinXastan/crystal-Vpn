import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import 'package:provider/provider.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/screens/widgets/glass_box.dart';
import 'package:vpn/services/nav_provider.dart';
import 'package:vpn/services/v2ray_services.dart';
import '../../gen/assets.gen.dart';

//در اینجا نیازی نیست همه کانفیگ ها رو به وی تو ری سرویس انتقال بدیم بلکه فقط کانفیگ انتخاب شده لازم است
class ProtocolScreen extends StatefulWidget {
  final List<ConfigModel> configs;
  final String protocolType;

  const ProtocolScreen({
    super.key,
    required this.configs,
    required this.protocolType,
  });

  @override
  State<ProtocolScreen> createState() => _ProtocolScreenState();
}

class _ProtocolScreenState extends State<ProtocolScreen> {
  late final V2ray flutterV2ray;
  late final V2rayService v2rayService;

  // --- متغیرهای وضعیت ---
  String v2rayState = "DISCONNECTED";
  final Map<String, int> _pingResults = {};
  ConfigModel? _selectedConfig;
  bool _isPingingAll = false;
  int _pingedCount = 0;
  List<ConfigModel> _displayConfigs = [];
  DateTime? _lastPingTime;

  int get totalConfigs => _displayConfigs.length;

  @override
  void initState() {
    super.initState();
    flutterV2ray = V2ray(
      onStatusChanged: (status) {
        if (mounted) {
          setState(() {
            v2rayState = status.state.toString().split('.').last;
          });
          log('V2Ray status: $v2rayState');
        }
      },
    );
    _initializeConfigs(widget.configs);
    v2rayService = context.read<V2rayService>();
  }

  @override
  void dispose() {
    // disconnect();
    super.dispose();
  }

  void _initializeConfigs(List<ConfigModel> configs) {
    _displayConfigs = List.from(configs);
    _pingResults.clear();
    for (var configModel in configs) {
      _pingResults[configModel.config] = 0;
    }
  }

  void selectConfig(ConfigModel? config) {
    v2rayService.setSelectConfig(config);

    v2rayService.setSelectedRemark(config);
    setState(() {
      _selectedConfig = config;
    });
  }

  Future<void> getAllPings() async {
    if (_isPingingAll) return;
    v2rayService.setIsPingingAll(true);
    v2rayService.setStatus(1);
    setState(() {
      _isPingingAll = true;
      _pingedCount = 0;
      _pingResults.updateAll((key, value) => 0);
    });

    try {
      await flutterV2ray.initialize();
    } catch (e) {
      log('Failed to initialize V2Ray for pinging: $e');
      if (mounted) {
        setState(() => _isPingingAll = false);
      }
      return;
    }

    final configsToPing = List<ConfigModel>.from(_displayConfigs);

    for (final configModel in configsToPing) {
      if (!_isPingingAll) break;

      if (mounted) {
        setState(() => _pingResults[configModel.config] = -3);
      }

      final result = await _getSinglePing(configModel);

      if (mounted) {
        setState(() {
          _pingResults[result.config] = result.delay;
          _pingedCount++;
        });
      }
    }

    _sortConfigsByPing();
  }

  /// گرفتن پینگ یک کانفیگ با استفاده از getServerDelay (نسخه اصلاح شده)
  Future<ConfigModel> _getSinglePing(ConfigModel configModel) async {
    final parser = _tryParse(configModel.config);
    if (parser == null) {
      return configModel.copyWith(delay: -2); // کانفیگ نامعتبر
    }
    try {
      // *** نکته کلیدی اینجاست ***
      // ما باید کانفیگ کامل را به متد بدهیم، نه لینک خام را
      final delay = await flutterV2ray
          .getServerDelay(
            config: parser.getFullConfiguration(),
            /* url: Conf.urlTestPing, */
          ) // <-- این خط اصلاح شد
          .timeout(const Duration(seconds: 10), onTimeout: () => -1);
      return configModel.copyWith(delay: delay);
    } catch (e) {
      log("Error getting ping for ${parser.remark}: $e");
      return configModel.copyWith(delay: -1); // خطا در پینگ
    }
  }

  void _sortConfigsByPing() {
    _displayConfigs.sort((a, b) {
      final int pingA = _pingResults[a.config] ?? -1;
      final int pingB = _pingResults[b.config] ?? -1;
      if (pingA > 0 && pingB <= 0) return -1;
      if (pingB > 0 && pingA <= 0) return 1;
      if (pingA > 0 && pingB > 0) return pingA.compareTo(pingB);
      return 0;
    });
    v2rayService.setIsPingingAll(false);
    v2rayService.setStatus(0);
    if (mounted) {
      setState(() {
        _lastPingTime = DateTime.now();
        _isPingingAll = false;
      });
    }
  }

  void stopPinging() {
    if (mounted) {
      v2rayService.setIsPingingAll(false);
      v2rayService.setStatus(0);
      v2rayService.setLastPingTime(DateTime.now());
      setState(() => _isPingingAll = false);
    }
  }

  /*  //TODO: باید درستش کنم جاش اینجا نیست
  Future<void> connect(ConfigModel config) async {
    //TODO: اینو باید در سرویس بخونه
    if (v2rayState == 'CONNECTED' || v2rayState == 'CONNECTING') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Already connected or connecting.")),
      );
      return;
    }

    selectConfig(config);

    final parser = _tryParse(config.config);
    if (parser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The selected config is invalid.")),
      );
      if (mounted) setState(() => v2rayState = "ERROR");
      return;
    }

    try {
      if (await flutterV2ray.requestPermission()) {
        await flutterV2ray.startV2Ray(
          remark: parser.remark,
          config: parser.getFullConfiguration(),
          proxyOnly: false,
        );
      }
    } catch (e) {
      log("Error starting V2Ray: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error starting V2Ray: $e")));
      if (mounted) setState(() => v2rayState = "ERROR");
    }
  } */

  /*  Future<void> disconnect() async {
    if (v2rayState != 'DISCONNECTED') {
      try {
        await flutterV2ray.stopV2Ray();
        selectConfig(null);
      } catch (e) {
        log('Error disconnecting from V2Ray: $e');
        if (mounted) setState(() => v2rayState = "ERROR");
      }
    }
  } */

  V2RayURL? _tryParse(String url) {
    try {
      return V2ray.parseFromURL(url);
    } catch (e) {
      log('Could not parse URL: $url. Error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.backgrounds.greenBackground.image(
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: _displayConfigs.length + 1,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return autoButton(size);
                      } else {
                        final dataIndex = index - 1;
                        final configItem = _displayConfigs[dataIndex];
                        final ping = _pingResults[configItem.config] ?? 0;

                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            12,
                            12,
                            12,
                            index == _displayConfigs.length ? 170 : 12,
                          ),
                          child: V2rayConfigBox(
                            size: size,
                            protocolType: widget.protocolType,
                            configs: configItem.config,
                            delay: ping,
                            isSelected:
                                _selectedConfig?.config == configItem.config,
                            onTap: () async {
                              selectConfig(configItem);
                              //await connect(configItem);
                              /* if (v2rayState == 'CONNECTING' ||
                                  v2rayState == 'CONNECTED') {
                                context.read<NavigationProvider>().changeTab(
                                  BtmNavScreenIndex.home,
                                );
                              } */
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              left: 16,
              bottom: size.height / 8,
              child: _buildRefreshButton(),
            ),
            Positioned(
              left: 0,
              top: 0,
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget autoButton(Size size) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 48, 12, 12),
      child: GestureDetector(
        onTap: () async {
          if (_isPingingAll) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('لطفاً تا پایان عملیات تست پینگ صبر کنید.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else {
            final now = DateTime.now();
            final lastPing =
                _lastPingTime ?? now.subtract(const Duration(days: 1));
            if (now.difference(lastPing).inHours >= 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'کانفیگ‌ها نیاز به تست مجدد دارند. تست پینگ شروع می‌شود.',
                  ),
                  backgroundColor: Colors.orangeAccent,
                ),
              );
              await getAllPings();
            }

            if (_displayConfigs.isNotEmpty) {
              final ConfigModel bestPing = _displayConfigs.first;
              selectConfig(bestPing);
              // await connect(bestPing);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('بهرترین کانفیگ انتخاب شد'),
                  backgroundColor: Color.fromARGB(255, 56, 255, 1),
                ),
              );
              context.read<NavigationProvider>().changeTab(
                BtmNavScreenIndex.home,
              );
            }
          }
        },
        child: GlassBox(
          width: size.width,
          height: size.height / 10,
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Color.fromARGB(255, 2, 255, 196),
                  size: 50,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Auto Select',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshButton() {
    if (_isPingingAll) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 75,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: Colors.black.withOpacity(0.5),
        ),
        child: InkWell(
          onTap: () => stopPinging(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$_pingedCount/$totalConfigs",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      width: 75,
      height: 75,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(18)),
        color: Color.fromARGB(255, 2, 255, 196),
      ),
      child: IconButton(
        onPressed: () => getAllPings(),
        icon: const Icon(Icons.speed_rounded, size: 36, color: Colors.black),
      ),
    );
  }
}

class V2rayConfigBox extends StatelessWidget {
  const V2rayConfigBox({
    super.key,
    required this.size,
    required this.protocolType,
    required this.configs,
    required this.delay,
    required this.onTap,
    this.isSelected = false,
  });

  final int delay;
  final Size size;
  final String protocolType;
  final String configs;
  final Function() onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    String getPingStatusText(int p) {
      if (p == 0) return '...';
      if (p == -1) return 'Error';
      if (p == -2) return 'Invalid';
      if (p == -3) return 'Pinging...';
      return '$p ms';
    }

    Color getPingStatusColor(int p) {
      if (p > 0) return Colors.greenAccent;
      if (p == -1 || p == -2) return Colors.redAccent;
      if (p == -3) return Colors.yellowAccent;
      return Colors.grey;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Colors.green.shade600.withOpacity(0.5) : null,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: const Color(0xFF00FFD1), width: 2.5)
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00FFD1).withOpacity(0.5),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: GlassBox(
          width: size.width,
          height: size.height / 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                const Icon(
                  Icons.security,
                  color: Color.fromARGB(255, 20, 255, 200),
                  size: 50,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _tryParse(configs)?.remark.trim() ?? protocolType,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        configs,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 8),
                    Text(
                      getPingStatusText(delay),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: getPingStatusColor(delay),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      delay > 0
                          ? Icons.check_circle
                          : (delay == -1 || delay == -2
                                ? Icons.error
                                : delay == -3
                                ? Icons.hourglass_top_rounded
                                : Icons.circle_outlined),
                      color: getPingStatusColor(delay),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  V2RayURL? _tryParse(String url) {
    try {
      return V2ray.parseFromURL(url);
    } catch (e) {
      return null;
    }
  }
}

extension ConfigModelCopyWith on ConfigModel {
  ConfigModel copyWith({String? config, int? delay}) {
    return ConfigModel(
      config: config ?? this.config,
      delay: delay ?? this.delay,
    );
  }
}

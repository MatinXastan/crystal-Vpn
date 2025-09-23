import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart'; // Import for _tryParse
import 'package:provider/provider.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/screens/widgets/glass_box.dart';
import 'package:vpn/services/v2ray_services.dart';
import '../../gen/assets.gen.dart';

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
  @override
  void initState() {
    super.initState();
    // در اولین اجرا، لیست کانفیگ‌ها را به سرویس می‌دهیم
    // از context.read استفاده می‌کنیم چون فقط یک بار نیاز به فراخوانی داریم
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<V2rayService>().initializeConfigs(widget.configs);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // با context.watch به سرویس گوش می‌دهیم. هر تغییری در سرویس باعث بازسازی این ویجت می‌شود
    final v2rayService = context.watch<V2rayService>();

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
                    // حالا از v2rayService.displayConfigs استفاده می‌کنیم
                    itemCount: v2rayService.displayConfigs.length + 1,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return autoButton(size, v2rayService);
                      } else {
                        final dataIndex = index - 1;
                        final configItem =
                            v2rayService.displayConfigs[dataIndex];
                        // نتایج پینگ را هم از سرویس می‌خوانیم
                        final ping =
                            v2rayService.pingResults[configItem.config] ?? 0;

                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            12,
                            12,
                            12,
                            index == v2rayService.displayConfigs.length
                                ? 170
                                : 12,
                          ),
                          child: V2rayConfigBox(
                            size: size,
                            protocolType: widget.protocolType,
                            configs: configItem.config,
                            delay: ping,
                            // وضعیت انتخاب شده را از سرویس می‌خوانیم
                            isSelected:
                                v2rayService.selectedConfig?.config ==
                                configItem.config,
                            onTap: () {
                              // برای انتخاب یک کانفیگ، متد سرویس را صدا می‌زنیم
                              context.read<V2rayService>().selectConfig(
                                configItem,
                              );
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
              // دکمه رفرش هم وضعیت خود را از سرویس می‌خواند
              child: _buildRefreshButton(v2rayService),
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

  Widget autoButton(Size size, V2rayService service) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 48, 12, 12),
      child: GestureDetector(
        onTap: () {
          if (service.isPingingAll) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(seconds: 3),
                content: Text(
                  'لطفاً تا پایان عملیات تست پینگ صبر کنید.',
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else {
            final now = DateTime.now();
            final lastPing =
                service.lastPingTime ?? now.subtract(const Duration(days: 1));
            if (now.difference(lastPing).inHours >= 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'بیش از 6 ساعت است که کانفیگ ها تست نشده اند. تست پینگ شروع می شود.',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.orangeAccent,
                ),
              );
              context.read<V2rayService>().getAllPings();
            } else {
              //TODO: باید برم به هوم اسکرین
              // Example: Navigator.of(context).popUntil((route) => route.isFirst);
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

  Widget _buildRefreshButton(V2rayService service) {
    if (service.isPingingAll) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 75,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(18)),
          color: Colors.black.withOpacity(0.5),
        ),
        child: InkWell(
          onTap: () => context.read<V2rayService>().stopPinging(),
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
                "${service.pingedCount}/${service.totalConfigs}",
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
        onPressed: () => context.read<V2rayService>().getAllPings(),
        icon: const Icon(Icons.speed_rounded, size: 36, color: Colors.black),
      ),
    );
  }
}

// ویجت V2rayConfigBox و اکستنشن به فایل اضافه شدند تا کامل باشد

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
      return FlutterV2ray.parseFromURL(url);
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

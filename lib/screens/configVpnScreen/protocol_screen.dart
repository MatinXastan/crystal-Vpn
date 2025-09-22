import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/screens/widgets/glass_box.dart';
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
  late final FlutterV2ray _flutterV2ray;
  String _v2rayState = "DISCONNECTED";

  final Map<String, int> _pingResults = {};
  ConfigModel? _selectedConfig;
  // وضعیت در حال تست همه سرورها
  bool _isPingingAll = false;
  int _pingedCount = 0;

  // ✅ [تغییر ۱]: یک لیست جدید برای نمایش و مرتب‌سازی ایجاد می‌کنیم تا لیست اصلی دستکاری نشود
  List<ConfigModel> _displayConfigs = [];
  DateTime? _lastPingTime;

  @override
  void initState() {
    super.initState();
    _flutterV2ray = FlutterV2ray(
      onStatusChanged: (status) {
        if (mounted) {
          setState(() => _v2rayState = status.state.toString().split('.').last);
        }
        log('V2Ray status: ${status.state}');
      },
    );

    // ✅ [تغییر ۲]: لیست نمایشی را با داده‌های اولیه که از ویجت پدر آمده پر می‌کنیم
    _displayConfigs = List.from(widget.configs);

    for (var configModel in widget.configs) {
      _pingResults[configModel.config] = 0;
    }
  }

  Future<void> _getAllPings() async {
    if (_isPingingAll) return;

    setState(() {
      _isPingingAll = true;
      _pingedCount = 0;
      for (var configModel in widget.configs) {
        _pingResults[configModel.config] = 0;
      }
    });

    try {
      await _flutterV2ray.initializeV2Ray();
    } catch (e) {
      log('Failed to initialize V2Ray: $e');
      if (mounted) setState(() => _isPingingAll = false);
      return;
    }
    final request = await _flutterV2ray.requestPermission();
    for (final configModel in _displayConfigs) {
      // حالا روی لیست نمایشی حلقه می‌زنیم
      if (!_isPingingAll) break;

      final configUrl = configModel.config;

      if (mounted) {
        setState(() {
          _pingResults[configUrl] = -3; // Pinging...
        });
      }

      final result = await _getSinglePingByConnecting(
        configModel,
        request: request,
      );

      if (mounted) {
        setState(() {
          _pingResults[result.config] = result.delay;
          _pingedCount++;
        });
      }
    }

    // ✅ [تغییر ۳]: بعد از اتمام حلقه، تابع مرتب‌سازی را فراخوانی می‌کنیم
    _sortConfigsByPing();
  }

  // ✅ [تغییر ۴]: یک تابع جداگانه برای مرتب‌سازی لیست ایجاد کردیم
  void _sortConfigsByPing() {
    if (mounted) {
      setState(() {
        _displayConfigs.sort((a, b) {
          // پینگ هر دو آیتم را از نقشه نتایج می‌خوانیم
          final int pingA = _pingResults[a.config] ?? -1;
          final int pingB = _pingResults[b.config] ?? -1;

          // قانون ۱: سرورهای سالم (پینگ مثبت) همیشه بالاتر از سرورهای خراب هستند
          if (pingA > 0 && pingB <= 0) {
            return -1; // a بالاتر قرار می‌گیرد
          }
          if (pingB > 0 && pingA <= 0) {
            return 1; // b بالاتر قرار می‌گیرد
          }

          // قانون ۲: اگر هر دو سرور سالم هستند، بر اساس پینگ کمتر مرتب کن (صعودی)
          if (pingA > 0 && pingB > 0) {
            return pingA.compareTo(pingB);
          }

          // قانون ۳: اگر هر دو خراب هستند، ترتیبشان مهم نیست
          return 0;
        });
        //برای ثبت تاریخ از آخرین باری که کانفیگ گرفته شد
        _lastPingTime = DateTime.now();

        // در نهایت وضعیت در حال تست را غیرفعال می‌کنیم
        _isPingingAll = false;
      });
    }
  }

  Future<ConfigModel> _getSinglePingByConnecting(
    ConfigModel configModel, {
    bool request = true,
  }) async {
    V2RayURL? parser;
    try {
      parser = _tryParse(configModel.config);
      if (parser == null) {
        return configModel.copyWith(delay: -2);
      }

      if (request) {
        await _flutterV2ray.startV2Ray(
          remark: parser.remark,
          config: parser.getFullConfiguration(),
        );
      }

      await Future.delayed(const Duration(seconds: 2));
      if (_v2rayState != 'CONNECTED') {
        await Future.delayed(const Duration(seconds: 2));
      }

      if (_v2rayState == 'CONNECTED') {
        final delay = await _flutterV2ray.getConnectedServerDelay();
        return configModel.copyWith(delay: delay > 0 ? delay : -1);
      } else {
        log(
          "Connection timed out or failed for ${parser.remark}. State: $_v2rayState",
        );
        return configModel.copyWith(delay: -1);
      }
    } catch (e) {
      log(
        "Error during connect-ping process for ${parser?.remark ?? 'config'}: $e",
      );
      return configModel.copyWith(delay: -1);
    } finally {
      await _flutterV2ray.stopV2Ray();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  V2RayURL? _tryParse(String url) {
    try {
      return FlutterV2ray.parseFromURL(url);
    } catch (e) {
      return null;
    }
  }

  void _stopPinging() {
    if (mounted) {
      setState(() {
        _isPingingAll = false;
      });
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
                      // اول شرط را بررسی کن
                      if (index == 0) {
                        return autoButton(size);
                      } else {
                        // حالا که مطمئن هستیم index بزرگتر از صفر است، متغیرها را تعریف کن
                        final dataIndex = index - 1;
                        // از dataIndex برای دسترسی به لیست استفاده کن
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
                            onTap: () {
                              setState(() => _selectedConfig = configItem);
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
        onTap: () {
          if (_isPingingAll) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
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
            final difference = now.difference(_lastPingTime!);

            if (difference.inHours >= 6) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 3),
                  content: Text(
                    'بیش از 6 ساعته که از کانفیگ ها تست نشده اند باید کانفیگ ها تست پینگ شوند',
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.redAccent,
                ),
              );
              _getAllPings();
            } else {
              //TODO: باید برم به هوم اسکرین
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
                  Icons.auto_awesome, // آیکون مناسب برای حالت خودکار
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
          onTap: _stopPinging,
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
                "${_pingedCount}/${widget.configs.length}",
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
        onPressed: _getAllPings,
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
    // ... (توابع getPingStatusText و getPingStatusColor بدون تغییر باقی می‌مانند)
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
          // ✅ [تغییر جدید اینجاست]
          color: isSelected
              ? Colors.green.shade600.withOpacity(
                  0.5,
                ) // رنگ سبز پررنگ در حالت انتخاب
              : null, // در حالت عادی، رنگ پس‌زمینه ندارد تا افکت شیشه‌ای دیده شود
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
              // ... بقیه کد بدون تغییر
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

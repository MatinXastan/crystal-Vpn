import 'package:flutter/material.dart';

import 'dart:developer';

import 'package:flutter_v2ray_client/flutter_v2ray.dart';

// For logging

// لیست کانفیگ‌های شما
// نکته: برخی از این کانفیگ‌ها ممکن است منقضی شده باشند یا به درستی توسط پکیج پارس نشوند.
List<String> configs = [
  'vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlx1RDgzQ1x1RERFOVx1RDgzQ1x1RERFQSBERSB8IFx1RDgzRFx1REQxMyBWTUVTUyB8IEB2MjIycmF5IFsxMF0iLA0KICAiYWRkIjogIjkxLjk5LjE4NS4yMTYiLA0KICAicG9ydCI6ICIyMDA4NiIsDQogICJpZCI6ICI3YmQ2YTFlYS1hMjIwLTRmMWMtYWZlZC02Y2ZiOGFiOTZhZDkiLA0KICAiYWlkIjogIjAiLA0KICAic2N5IjogImF1dG8iLA0KICAibmV0IjogIndzIiwNCiAgInR5cGUiOiAiLS0tIiwNCiAgImhvc3QiOiAiIiwNCiAgInBhdGgiOiAiLyIsDQogICJ0bHMiOiAiIiwNCiAgInNuaSI6ICIiLA0KICAiYWxwbiI6ICIiLA0KICAiZnAiOiAiIg0KfQ==',
  'vless://df0680ca-e43c-498d-ed86-8e196eedd012@638938755008244100.vienna-drc-tusacaf.info:8880?encryption=none&security=none&type=grpc#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40v2aryng_vpn%20%5B8%5D',
  'vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlx1RDgzQ1x1RERFOVx1RDgzQ1x1RERFQSBERSB8IFx1RDgzRFx1REQxMyBWTUVTUyB8IEB2MnJheV9mcmVlX2NvbmYgWzddIiwNCiAgImFkZCI6ICI1Ny4xMjkuMjguMjEyIiwNCiAgInBvcnQiOiAiNDQzIiwNCiAgImlkIjogIjAzZmNjNjE4LWI5M2QtNjc5Ni02YWVkLThhMzhjOTc1ZDU4MSIsDQogICJhaWQiOiAiMCIsDQogICJzY3kiOiAiYXV0byIsDQogICJuZXQiOiAid3MiLA0KICAidHlwZSI6ICJhdXRvIiwNCiAgImhvc3QiOiAiZmFwZW5nLm9yZyIsDQogICJwYXRoIjogImxpbmt2d3MiLA0KICAidGxzIjogInRscyIsDQogICJzbmkiOiAiZmFwZW5nLm9yZyIsDQogICJhbHBuIjogIiIsDQogICJmcCI6ICIiDQp9',
  'vless://df0680ca-e43c-498d-ed86-8e196eedd012@638943444955046930.birjand-drc-tusacaf.info:8880?encryption=none&security=none&type=grpc#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40flyv2ray%20%5B9%5D',
  'vless://3940e9ba-d0f6-4052-bd8e-f3c2a2a76599@155.254.35.78:33811?encryption=none&security=reality&sni=miro.com&fp=chrome&pbk=fa3n6JDInXvPSrde2HYqogCf2YheiIgxhhO3N3gO1Qs&sid=63f811342e9c75&spx=%2F&type=grpc&authority=&serviceName=miro.com&mode=gun#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%92%20VLESS%20%7C%20%40v2ray1_ng%20%5B6%5D',
  'vless://1b5f6283-4872-4048-bb9b-308bc305cb0c@91.98.22.20:22933?encryption=none&security=none&type=tcp&headerType=http&host=speedtest.net#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40kingofilter%20%5B1%5D',
  'vless://3940e9ba-d0f6-4052-bd8e-f3c2a2a76599@155.254.35.78:33811?encryption=none&security=reality&sni=miro.com&fp=chrome&pbk=fa3n6JDInXvPSrde2HYqogCf2YheiIgxhhO3N3gO1Qs&sid=63f811342e9c75&spx=%2F&type=grpc&authority=&serviceName=miro.com&mode=gun#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%92%20VLESS%20%7C%20%40v2ray1_ng%20%5B6%5D',
  'vless://5fda29b6-0688-44e3-afdf-df533c800109@51.89.118.126:25369?encryption=none&security=none&type=grpc&authority=&serviceName=ZEDMODEON-ZEDMODEON-bia-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON&mode=gun#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40v2rayopen%20%5B3%5D',
  'vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlx1RDgzQ1x1RERFOVx1RDgzQ1x1RERFQSBERSB8IFx1RDgzRFx1REQxMiBWTUVTUyB8IEB2MnJheTFfbmcgWzJdIiwNCiAgImFkZCI6ICJ5aWNodWVuZy5vcmciLA0KICAicG9ydCI6ICI0NDMiLA0KICAiaWQiOiAiMDNmY2M2MTgtYjkzZC02Nzk2LTZhZWQtOGEzOGM5NzVkNTgxIiwNCiAgImFpZCI6ICIwIiwNCiAgInNjeSI6ICJhdXRvIiwNCiAgIm5ldCI6ICJ3cyIsDQogICJ0eXBlIjogIi0tLSIsDQogICJob3N0IjogInlpY2h1ZW5nLm9yZyIsDQogICJwYXRoIjogImxpbmt2d3MiLA0KICAidGxzIjogInRscyIsDQogICJzbmkiOiAieWljaHVlbmcub3JnIiwNCiAgImFscG4iOiAiIiwNCiAgImZwIjogIiINCn0=',
];

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String _v2rayState = "DISCONNECTED";
  late final V2ray _flutterV2ray;

  // برای نگهداری نتایج پینگ هر کانفیگ
  // Key: کانفیگ (URL), Value: پینگ (ms)
  final Map<String, int> _pingResults = {};

  // برای نگهداری کانفیگ انتخاب شده توسط کاربر
  String? _selectedConfig;
  bool _isPingingAll = false;

  @override
  void initState() {
    super.initState();
    _flutterV2ray = V2ray(
      onStatusChanged: (status) {
        setState(() {
          _v2rayState = status.state.toString().split('.').last;
        });
        log('V2Ray status: ${status.state}');
      },
    );

    // مقداردهی اولیه نتایج پینگ
    for (var config in configs) {
      _pingResults[config] = 0; // 0 به معنی پینگ گرفته نشده
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("V2Ray Test"),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Center(child: Text('Status: $_v2rayState')),
            ),
          ],
        ),
        body: Column(
          children: [
            _buildControlPanel(),
            Expanded(
              child: ListView.builder(
                itemCount: configs.length,
                itemBuilder: (context, index) {
                  final config = configs[index];
                  final ping = _pingResults[config] ?? 0;
                  final parser = _tryParse(config);
                  final remark = parser?.remark ?? 'Invalid Config';

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    child: ListTile(
                      title: Text(remark, overflow: TextOverflow.ellipsis),
                      subtitle: Text(
                        _getPingStatusText(ping),
                        style: TextStyle(color: _getPingStatusColor(ping)),
                      ),
                      tileColor: _selectedConfig == config
                          ? Colors.blue.withOpacity(0.2)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedConfig = config;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // پنل دکمه‌های کنترلی
  Widget _buildControlPanel() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (_selectedConfig != null)
            Text(
              "Selected: ${_tryParse(_selectedConfig!)?.remark ?? 'N/A'}",
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _isPingingAll ? null : _getAllPings,
                child: _isPingingAll
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Get All Pings'),
              ),
              ElevatedButton(
                onPressed: _startV2ray,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Start"),
              ),
              ElevatedButton(
                onPressed: _stopV2ray,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Stop"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // تلاش برای پارس کردن کانفیگ بدون ایجاد خطا
  V2RayURL? _tryParse(String url) {
    try {
      return V2ray.parseFromURL(url);
    } catch (e) {
      return null;
    }
  }

  // نمایش متن وضعیت پینگ
  String _getPingStatusText(int ping) {
    if (ping == 0) return 'Ping not tested';
    if (ping == -1) return 'Ping Error';
    if (ping == -2) return 'Invalid Config';
    if (ping == -3) return 'Pinging...';
    return 'Ping: ${ping}ms';
  }

  // رنگ متن وضعیت پینگ
  Color _getPingStatusColor(int ping) {
    if (ping > 0) return Colors.green;
    if (ping == -1 || ping == -2) return Colors.red;
    return Colors.grey;
  }

  // گرفتن پینگ برای همه کانفیگ‌ها
  Future<void> _getAllPings() async {
    setState(() {
      _isPingingAll = true;
    });

    for (final config in configs) {
      // نمایش وضعیت "در حال پینگ"
      setState(() {
        _pingResults[config] = -3;
      });

      final parser = _tryParse(config);
      if (parser == null) {
        setState(() {
          _pingResults[config] = -2; // کانفیگ نامعتبر
        });
        continue; // برو سراغ کانفیگ بعدی
      }

      try {
        final delay = await _flutterV2ray
            .getServerDelay(config: parser.getFullConfiguration())
            .timeout(
              const Duration(seconds: 7),
              onTimeout: () => -1, // مقدار پیش‌فرض در صورت تایم‌اوت
            );
        setState(() {
          _pingResults[config] = delay;
        });
      } catch (e) {
        log("Error getting ping for ${parser.remark}: $e");
        setState(() {
          _pingResults[config] = -1; // خطا در پینگ
        });
      }
    }

    setState(() {
      _isPingingAll = false;
    });
  }

  // شروع اتصال V2Ray
  Future<void> _startV2ray() async {
    if (_selectedConfig == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a config first!")),
      );
      return;
    }

    final parser = _tryParse(_selectedConfig!);
    if (parser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The selected config is invalid.")),
      );
      return;
    }

    try {
      if (await _flutterV2ray.requestPermission()) {
        await _flutterV2ray.startV2Ray(
          remark: parser.remark,
          config: parser.getFullConfiguration(),
          blockedApps: null,
          bypassSubnets: null,
          proxyOnly: false,
        );
      }
    } catch (e) {
      log("Error starting V2Ray: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error starting V2Ray: $e")));
    }
  }

  // قطع اتصال V2Ray
  void _stopV2ray() {
    _flutterV2ray.stopV2Ray();
  }
}

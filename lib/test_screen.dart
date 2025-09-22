import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'dart:developer';

import 'package:vpn/configurations/conf.dart'; // For logging

// لیست کانفیگ‌های شما
// نکته: برخی از این کانفیگ‌ها ممکن است منقضی شده باشند یا به درستی توسط پکیج پارس نشوند.
List<String> configs = [
  'vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlx1RDgzQ1x1RERFOVx1RDgzQ1x1RERFQSBERSB8IFx1RDgzRFx1REQxMyBWTUVTUyB8IEB2cG5mYWlsX3YycmF5IFsxNl0iLA0KICAiYWRkIjogImthbXBvbmcub3JnIiwNCiAgInBvcnQiOiAiNDQzIiwNCiAgImlkIjogIjAzZmNjNjE4LWI5M2QtNjc5Ni02YWVkLThhMzhjOTc1ZDU4MSIsDQogICJhaWQiOiAiMSIsDQogICJzY3kiOiAiYXV0byIsDQogICJuZXQiOiAid3MiLA0KICAidHlwZSI6ICJhdXRvIiwNCiAgImhvc3QiOiAia2FtcG9uZy5vcmciLA0KICAicGF0aCI6ICJsaW5rdndzIiwNCiAgInRscyI6ICJ0bHMiLA0KICAic25pIjogImthbXBvbmcub3JnIiwNCiAgImFscG4iOiAiIiwNCiAgImZwIjogIiINCn0=',
  'vless://4981b98f-4943-4083-83aa-00b028f57a18@57.129.92.155:36626?encryption=none&security=none&type=grpc&authority=&serviceName=ZEDMODEON-ZEDMODEON-ZEDMODEON-bia-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON&mode=gun#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40orange_vpns%20%5B15%5D',
  'vless://7a3d2e42-3823-4b00-9818-293f7c6742ca@zonex.de.zopli.ir:33667?encryption=none&flow=xtls-rprx-vision&security=reality&sni=store.steampowered.com&fp=firefox&pbk=urkddCRB1-01SWciigBk31sfccR6KZr4wX_BInUHu3o&sid=382874842551202c&type=tcp&headerType=none#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%92%20VLESS%20%7C%20%40ehsawn8%20%5B11%5D',
  'vless://5fda29b6-0688-44e3-afdf-df533c800109@51.89.118.126:25369?encryption=none&security=none&type=grpc&authority=&serviceName=ZEDMODEON-ZEDMODEON-bia-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON-ZEDMODEON&mode=gun#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40vpnv2raytop%20%5B2%5D',
  'vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlx1RDgzQ1x1RERFOVx1RDgzQ1x1RERFQSBERSB8IFx1RDgzRFx1REQxMiBWTUVTUyB8IEBmcmVlNGFsbHZwbiBbMTZdIiwNCiAgImFkZCI6ICJmYXBlbmcub3JnIiwNCiAgInBvcnQiOiAiNDQzIiwNCiAgImlkIjogIjAzZmNjNjE4LWI5M2QtNjc5Ni02YWVkLThhMzhjOTc1ZDU4MSIsDQogICJhaWQiOiAiMCIsDQogICJzY3kiOiAiYXV0byIsDQogICJuZXQiOiAid3MiLA0KICAidHlwZSI6ICItLS0iLA0KICAiaG9zdCI6ICJmYXBlbmcub3JnIiwNCiAgInBhdGgiOiAibGlua3Z3cyIsDQogICJ0bHMiOiAidGxzIiwNCiAgInNuaSI6ICJmYXBlbmcub3JnIiwNCiAgImFscG4iOiAiIiwNCiAgImZwIjogIiINCn0=',
  'vless://234a4937-5029-4bcd-b32a-1eda5afc14f8@91.98.22.20:22933?encryption=none&security=none&type=tcp&headerType=http&host=speedtest.net#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40kingofilter%20%5B4%5D',
  'vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlx1RDgzQ1x1RERFOVx1RDgzQ1x1RERFQSBERSB8IFx1RDgzRFx1REQxMiBWTUVTUyB8IEBvdXRsaW5ldjJyYXluZyBbMTNdIiwNCiAgImFkZCI6ICJsYW1tYWxhbmQub3JnIiwNCiAgInBvcnQiOiAiNDQzIiwNCiAgImlkIjogIjAzZmNjNjE4LWI5M2QtNjc5Ni02YWVkLThhMzhjOTc1ZDU4MSIsDQogICJhaWQiOiAiMCIsDQogICJzY3kiOiAiYXV0byIsDQogICJuZXQiOiAid3MiLA0KICAidHlwZSI6ICItLS0iLA0KICAiaG9zdCI6ICJsYW1tYWxhbmQub3JnIiwNCiAgInBhdGgiOiAibGlua3Z3cyIsDQogICJ0bHMiOiAidGxzIiwNCiAgInNuaSI6ICJsYW1tYWxhbmQub3JnIiwNCiAgImFscG4iOiAiIiwNCiAgImZwIjogIiINCn0=',
  'vmess://ew0KICAidiI6ICIyIiwNCiAgInBzIjogIlx1RDgzQ1x1RERFOVx1RDgzQ1x1RERFQSBERSB8IFx1RDgzRFx1REQxMyBWTUVTUyB8IEB2cG5mYWlsX3YycmF5IFsxNl0iLA0KICAiYWRkIjogImthbXBvbmcub3JnIiwNCiAgInBvcnQiOiAiNDQzIiwNCiAgImlkIjogIjAzZmNjNjE4LWI5M2QtNjc5Ni02YWVkLThhMzhjOTc1ZDU4MSIsDQogICJhaWQiOiAiMSIsDQogICJzY3kiOiAiYXV0byIsDQogICJuZXQiOiAid3MiLA0KICAidHlwZSI6ICJhdXRvIiwNCiAgImhvc3QiOiAia2FtcG9uZy5vcmciLA0KICAicGF0aCI6ICJsaW5rdndzIiwNCiAgInRscyI6ICJ0bHMiLA0KICAic25pIjogImthbXBvbmcub3JnIiwNCiAgImFscG4iOiAiIiwNCiAgImZwIjogIiINCn0=',
  'vless://defb9686-1d5d-4919-a87f-c93b54b9c0d3@91.98.41.123:28260?encryption=none&security=none&type=tcp&headerType=none#%F0%9F%87%A9%F0%9F%87%AA%20DE%20%7C%20%F0%9F%94%93%20VLESS%20%7C%20%40v2rayng3%20%5B6%5D',
];

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String _v2rayState = "DISCONNECTED";
  late final FlutterV2ray _flutterV2ray;

  // برای نگهداری نتایج پینگ هر کانفیگ
  // Key: کانفیگ (URL), Value: پینگ (ms)
  final Map<String, int> _pingResults = {};

  // برای نگهداری کانفیگ انتخاب شده توسط کاربر
  String? _selectedConfig;
  bool _isPingingAll = false;

  @override
  void initState() {
    super.initState();
    _flutterV2ray = FlutterV2ray(
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
      return FlutterV2ray.parseFromURL(url);
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
        final delay = await _flutterV2ray.getServerDelay(
          config: parser.getFullConfiguration(),
          url: Conf.urlTestPing,
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

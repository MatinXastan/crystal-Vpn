import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_v2ray/flutter_v2ray.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/screens/configVpnScreen/protocol_screen.dart';
// import 'package:vpn/screens/configVpnScreen/protocol_screen.dart'; // این import استفاده نشده بود

// کلاس سرویس ما که از ChangeNotifier ارث‌بری می‌کند تا بتواند به UI اطلاع‌رسانی کند
class V2rayService with ChangeNotifier {
  // سازنده کلاس عمومی شده و دیگر خصوصی نیست
  V2rayService() {
    // مقداردهی اولیه در سازنده انجام می‌شود
    flutterV2ray = FlutterV2ray(
      onStatusChanged: (status) {
        v2rayState = status.state.toString().split('.').last;
        log('V2Ray status: ${v2rayState}');
        notifyListeners(); // به ویجت‌ها اطلاع بده که وضعیت عوض شده
      },
    );
  }

  late final FlutterV2ray flutterV2ray;

  // --- متغیرهای وضعیت ---
  String v2rayState = "DISCONNECTED";
  final Map<String, int> _pingResults = {};
  ConfigModel? _selectedConfig;
  bool _isPingingAll = false;
  int _pingedCount = 0;
  List<ConfigModel> _displayConfigs = [];
  DateTime? _lastPingTime;

  // --- Getter ها برای دسترسی امن به متغیرها از بیرون ---
  bool get isPingingAll => _isPingingAll;
  int get pingedCount => _pingedCount;
  int get totalConfigs => _displayConfigs.length;
  List<ConfigModel> get displayConfigs => _displayConfigs;
  ConfigModel? get selectedConfig => _selectedConfig;
  Map<String, int> get pingResults => _pingResults;
  DateTime? get lastPingTime => _lastPingTime;

  // متد برای مقداردهی اولیه لیست کانفیگ‌ها
  void initializeConfigs(List<ConfigModel> configs) {
    _displayConfigs = List.from(configs);
    _pingResults.clear();
    for (var configModel in configs) {
      _pingResults[configModel.config] = 0;
    }
    // به UI اطلاع می‌دهیم که لیست اولیه آماده است (اختیاری)
    notifyListeners();
  }

  void selectConfig(ConfigModel? config) {
    _selectedConfig = config;
    notifyListeners();
  }

  // --- منطق اصلی برنامه ---
  Future<void> getAllPings() async {
    if (_isPingingAll) return;

    _isPingingAll = true;
    _pingedCount = 0;
    // ریست کردن نتایج پینگ‌های قبلی
    _pingResults.updateAll((key, value) => 0);
    notifyListeners(); // اطلاع به UI که پینگ شروع شده

    try {
      await flutterV2ray.initializeV2Ray();
    } catch (e) {
      log('Failed to initialize V2Ray: $e');
      _isPingingAll = false;
      notifyListeners();
      return;
    }
    final request = await flutterV2ray.requestPermission();
    // ایجاد یک کپی از لیست برای جلوگیری از خطای همزمان در حین پیمایش و مرتب‌سازی
    final configsToPing = List<ConfigModel>.from(_displayConfigs);

    for (final configModel in configsToPing) {
      if (!_isPingingAll) break;

      final configUrl = configModel.config;
      _pingResults[configUrl] = -3; // Pinging...
      notifyListeners();

      final result = await _getSinglePingByConnecting(
        configModel,
        request: request,
      );

      _pingResults[result.config] = result.delay;
      _pingedCount++;
      notifyListeners();
    }

    _sortConfigsByPing();
  }

  void _sortConfigsByPing() {
    _displayConfigs.sort((a, b) {
      final int pingA = _pingResults[a.config] ?? -1;
      final int pingB = _pingResults[b.config] ?? -1;

      // کانفیگ با پینگ مثبت (موفق) بالاتر از کانفیگ با پینگ ناموفق قرار می‌گیرد
      if (pingA > 0 && pingB <= 0) return -1;
      if (pingB > 0 && pingA <= 0) return 1;

      // اگر هر دو پینگ موفق بودند، بر اساس پینگ کمتر مرتب می‌شوند
      if (pingA > 0 && pingB > 0) return pingA.compareTo(pingB);

      // در غیر این صورت ترتیب فعلی حفظ می‌شود
      return 0;
    });
    _lastPingTime = DateTime.now();
    _isPingingAll = false;
    notifyListeners(); // به UI اطلاع می‌دهیم که مرتب‌سازی تمام شده
  }

  void stopPinging() {
    _isPingingAll = false;
    notifyListeners();
  }

  // متدهای کمکی دیگر مثل _getSinglePingByConnecting و _tryParse
  // این متدها خصوصی باقی می‌مانند و از بیرون قابل دسترسی نیستند
  Future<ConfigModel> _getSinglePingByConnecting(
    ConfigModel configModel, {
    bool request = true,
  }) async {
    V2RayURL? parser;
    try {
      parser = _tryParse(configModel.config);
      if (parser == null) {
        return configModel.copyWith(delay: -2); // Invalid config format
      }

      // نیازی به این شرط نیست چون مقداردهی اولیه در getAllPings انجام شده است
      // if (request) {
      await flutterV2ray.startV2Ray(
        remark: parser.remark,
        config: parser.getFullConfiguration(),
        proxyOnly: true, // برای تست پینگ بهتر است این گزینه فعال باشد
      );
      // }

      await Future.delayed(const Duration(seconds: 2));
      if (v2rayState != 'CONNECTED') {
        await Future.delayed(const Duration(seconds: 2));
      }

      if (v2rayState == 'CONNECTED') {
        final delay = await flutterV2ray.getConnectedServerDelay();
        return configModel.copyWith(delay: delay > 0 ? delay : -1);
      } else {
        log(
          "Connection timed out or failed for ${parser.remark}. State: $v2rayState",
        );
        return configModel.copyWith(delay: -1);
      }
    } catch (e) {
      log(
        "Error during connect-ping process for ${parser?.remark ?? 'config'}: $e",
      );
      return configModel.copyWith(delay: -1);
    } finally {
      await flutterV2ray.stopV2Ray();
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  V2RayURL? _tryParse(String url) {
    try {
      return FlutterV2ray.parseFromURL(url);
    } catch (e) {
      log('Could not parse URL: $url. Error: $e');
      return null;
    }
  }

  Future<List<ConfigModel>> connectAuto() async {
    /* if (displayConfigs.length > 1) {
      
    }else{

    } */
    final DateTime now = DateTime.now();
    final diffrence = now.difference(
      _lastPingTime ?? now.subtract(const Duration(days: 1)),
    );
    if (diffrence.inHours >= 6) {
      try {
        await getAllPings();
        return displayConfigs;
      } catch (e) {
        throw Exception('Error during auto-connect ping: $e');
      }
    } else {
      return displayConfigs;
    }
  }
}

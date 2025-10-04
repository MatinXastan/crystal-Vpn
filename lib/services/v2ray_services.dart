import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import 'package:vpn/data/model/config_advanced_model.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/screens/configVpnScreen/protocol_screen.dart';

// کلاس سرویس ما که از ChangeNotifier ارث‌بری می‌کند تا بتواند به UI اطلاع‌رسانی کند
class V2rayService with ChangeNotifier {
  // سازنده کلاس عمومی شده و دیگر خصوصی نیست

  // --- متغیرهای وضعیت ---
  int status = 0;
  String v2rayState = "DISCONNECTED";
  final Map<String, int> _pingResults = {};
  ConfigModel? _selectedConfig;
  bool _isPingingAll = false;
  int _pingedCount = 0;
  List<ConfigModel> _displayConfigs = [];
  DateTime? _lastPingTime;
  String? _selectedRemark;
  //ConfigAdvancedModel _autoAdvancedConfigs = [] as ConfigAdvancedModel;

  // --- Getter ها برای دسترسی امن به متغیرها از بیرون ---
  bool get isPingingAll => _isPingingAll;
  int get pingedCount => _pingedCount;
  int get totalConfigs => _displayConfigs.length;
  List<ConfigModel> get displayConfigs => _displayConfigs;
  ConfigModel? get selectedConfig => _selectedConfig;
  Map<String, int> get pingResults => _pingResults;
  DateTime? get lastPingTime => _lastPingTime;
  // ConfigAdvancedModel get getAutoAdvancedConfigs => _autoAdvancedConfigs;
  String get statuseVpn => v2rayState;
  int get statusConnection => status;

  String? get selectedRemark => _selectedRemark;
  // متد برای مقداردهی اولیه لیست کانفیگ‌ها
  /*  void initializeConfigs(List<ConfigModel> configs) {
    _displayConfigs = List.from(configs);
    _pingResults.clear();
    for (var configModel in configs) {
      _pingResults[configModel.config] = 0;
    }
    // به UI اطلاع می‌دهیم که لیست اولیه آماده است (اختیاری)
    notifyListeners();
  } */
  void setStatus(int currentStatus) {
    status = currentStatus;
    notifyListeners();
  }

  void setV2rayState(String currentV2rayState) {
    v2rayState = currentV2rayState;
    notifyListeners();
  }

  void setSelectConfig(ConfigModel? config) {
    _selectedConfig = config;
    notifyListeners();
  }

  void setSelectedRemark(ConfigModel? config) {
    ConfigModel? configModel = config;
    if (configModel != null) {
      var currentRemark = _tryParse(configModel.config)?.remark;
      _selectedRemark = currentRemark;
      notifyListeners();
    }
  }

  void setIsPingingAll(bool isPingAll) {
    _isPingingAll = isPingAll;
    notifyListeners();
  }

  void stopPinging() {
    _isPingingAll = false;
    status = 0;
    notifyListeners();
  }

  void setLastPingTime(DateTime time) {
    _lastPingTime = time;
    notifyListeners();
  }

  void setDisplayConfigs(List<ConfigModel> newDisplayConfigs) {
    _displayConfigs = newDisplayConfigs;
    notifyListeners();
  }

  V2RayURL? _tryParse(String url) {
    try {
      return V2ray.parseFromURL(url);
    } catch (e) {
      return null;
    }
  }
  /* 
  void setAdvancedAutoConfigs(ConfigAdvancedModel newDisplayConfigs) {
    _autoAdvancedConfigs = newDisplayConfigs;
    notifyListeners();
  } */

  /* 
  // --- منطق اصلی برنامه ---
  Future<void> getAllPings() async {
    if (_isPingingAll) return;

    _isPingingAll = true;
    status = 1;
    _pingedCount = 0;
    notifyListeners();
    // ریست کردن نتایج پینگ‌های قبلی
    _pingResults.updateAll((key, value) => 0);
    notifyListeners(); // اطلاع به UI که پینگ شروع شده

    try {
      await flutterV2ray.initialize();
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
      return V2ray.parseFromURL(url);
    } catch (e) {
      log('Could not parse URL: $url. Error: $e');
      return null;
    }
  }

  /// متد برای اتصال خودکار به بهترین کانفیگ بر اساس پینگ
  /// همچنین چک بر اساس تاریخ چک میکنه اگه کانفیگ ها قدیمی باشند اول تست پینگ میگیره بعد کانکیت میشه به بهترین پیمنگ
  Future<void> connectAuto() async {
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
        notifyListeners();
        final bestConfigPing = displayConfigs.first;
        await connect(bestConfigPing);
        notifyListeners();
      } catch (e) {
        status = 3;
        notifyListeners();
        throw Exception('Error during auto-connect ping: $e');
      }
    } else {
      final bestConfigPing = displayConfigs.first;
      await connect(bestConfigPing);
    }
  }

  /// متد برای قطع اتصال VPN
  Future<void> disconnect() async {
    // فقط در صورتی که اتصال برقرار باشد، آن را قطع می‌کنیم
    if (v2rayState != 'DISCONNECTED') {
      try {
        await flutterV2ray.stopV2Ray();
        // پس از قطع اتصال، کانفیگ انتخاب شده را null می‌کنیم
        status = 0;
        selectConfig(null);
        notifyListeners();
      } catch (e) {
        log('Error disconnecting from V2Ray: $e');
        v2rayState = "ERROR";
        status = 3;
        notifyListeners();
      }
    }
  }

  /// متد برای وصل شدن به یک کانفیگ مشخص
  /// این متد کانفیگ را به عنوان ورودی می‌گیرد و سعی می‌کند به آن متصل شود
  Future<void> connect(ConfigModel config) async {
    // اگر در حال اتصال یا از قبل وصل بودیم، دوباره تلاش نمی‌کنیم
    if (v2rayState == 'CONNECTED' || v2rayState == 'CONNECTING') {
      log('Already connected or in the process of connecting.');
      return;
    }

    // ابتدا کانفیگ ورودی را به عنوان کانفیگ انتخاب شده ذخیره می‌کنیم
    selectConfig(config);

    final parser = _tryParse(config.config);
    if (parser == null) {
      log('Error: Invalid config format.');
      v2rayState = "ERROR";
      notifyListeners();
      return;
    }

    try {
      // فرآیند اتصال را با کانفیگ کامل شروع می‌کنیم
      // proxyOnly باید false باشد تا کل دستگاه به VPN وصل شود
      await flutterV2ray.startV2Ray(
        remark: parser.remark,
        config: parser.getFullConfiguration(),
        proxyOnly: false,
      );
      status = 2;
      notifyListeners();
    } catch (e) {
      log('Error connecting to V2Ray: $e');
      v2rayState = "ERROR";
      status = 3;
      notifyListeners();
    }
  }
 */
}

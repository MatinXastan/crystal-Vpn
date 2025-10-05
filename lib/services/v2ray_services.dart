import 'package:flutter/material.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';

import 'package:vpn/data/model/config_model.dart';

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
  V2RayStatus _v2rayStatus = V2RayStatus();
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
  V2RayStatus get v2rayStatus => _v2rayStatus;

  String? get selectedRemark => _selectedRemark;

  void setStatus(int currentStatus) {
    status = currentStatus;
    notifyListeners();
  }

  void updateV2rayStatus(V2RayStatus v2Status) {
    print("status is : $v2Status");
    _v2rayStatus = v2Status;
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
}

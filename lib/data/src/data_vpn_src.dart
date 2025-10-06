import 'package:hive/hive.dart';
import 'package:vpn/data/model/vpn_model.dart';

// این اینترفیس، قراردادهای DataSource را برای کار با داده‌های VPN مشخص می‌کند
abstract class IVpnDataSrc {
  Future<List<VpnModel>> getAllVpns();
  Future<void> saveVpn(VpnModel vpn, String id);
  Future<void> deleteVpn(String configKey);
  Future<void> saveAllVpns(List<VpnModel> vpns);
}

class DataVpnSrc implements IVpnDataSrc {
  final Box<VpnModel> _vpnBox;

  // باکس Hive از طریق Constructor به این کلاس تزریق می شود
  DataVpnSrc(this._vpnBox);

  @override
  Future<List<VpnModel>> getAllVpns() async {
    return _vpnBox.values.toList();
  }

  // اصلاح شده: از vpn.config به عنوان کلید استفاده می شود
  @override
  Future<void> saveVpn(VpnModel vpn, String id) async {
    await _vpnBox.put(id, vpn);
  }

  // اصلاح شده: کلید همان vpn.config است
  @override
  Future<void> deleteVpn(String configKey) async {
    await _vpnBox.delete(configKey);
  }

  // اصلاح شده: از vpn.config به عنوان کلید Map استفاده می شود
  @override
  Future<void> saveAllVpns(List<VpnModel> vpns) async {
    // ⭐️ تغییر اصلی اینجاست ⭐️
    final Map<String, VpnModel> vpnMap = {
      for (var vpn in vpns) vpn.config: vpn,
    };

    await _vpnBox.putAll(vpnMap);
  }
}


/* import 'package:hive/hive.dart';

/// یک قرارداد (Interface) برای منبع داده محلی کانفیگ‌ها.
/// این کلاس مشخص می‌کند که هر منبع داده محلی باید چه متدهایی داشته باشد.
abstract class IConfigHiveDataSource {
  Future<void> saveConfigs(String fileName, List<String> configs);
  List<String>? getConfigs(String fileName);
  Future<void> deleteConfigs(String fileName);
  Future<void> clearAllConfigs();
}


/// این کلاس، پیاده‌سازی دیتاسورس محلی با استفاده از Hive است.
/// و تمام منطق مربوط به ذخیره، خواندن و حذف لیست کانفیگ‌ها را در خود کپسوله می‌کند.
class ConfigHiveDataSource implements IConfigHiveDataSource {
  // نام باکس باید با نامی که در main.dart باز کرده‌اید یکی باشد.
  static const String _boxName = 'vpn_configs';

  // یک getter خصوصی برای دسترسی راحت‌تر به باکس باز شده
  Box<List<String>> get _box => Hive.box<List<String>>(_boxName);

  /// لیستی از کانفیگ‌ها را برای یک فایل مشخص در Hive ذخیره می‌کند.
  /// [fileName] به عنوان کلید (key) و [configs] به عنوان مقدار (value) استفاده می‌شود.
  @override
  Future<void> saveConfigs(String fileName, List<String> configs) async {
    // متد put یک جفت کلید-مقدار را در باکس ذخیره می‌کند.
    // اگر کلید از قبل وجود داشته باشد، مقدار آن آپدیت می‌شود.
    print("Saving ${configs.length} configs for '$fileName' to Hive.");
    await _box.put(fileName, configs);
  }

  /// لیست کانفیگ‌های ذخیره شده برای یک فایل مشخص را از Hive می‌خواند.
  /// اگر کانفیگی برای این [fileName] وجود نداشته باشد، null برمی‌گرداند.
  @override
  List<String>? getConfigs(String fileName) {
    // متد get مقدار مرتبط با کلید را برمی‌گرداند.
    final configs = _box.get(fileName);
    if (configs != null) {
      print("Found ${configs.length} cached configs for '$fileName' in Hive.");
      // تبدیل List<dynamic> به List<String> برای اطمینان از نوع داده
      return List<String>.from(configs);
    }
    print("No cached configs found for '$fileName' in Hive.");
    return null;
  }

  /// کانفیگ‌های مربوط به یک فایل را از Hive حذف می‌کند.
  @override
  Future<void> deleteConfigs(String fileName) async {
    print("Deleting configs for '$fileName' from Hive.");
    await _box.delete(fileName);
  }

  /// تمام داده‌های موجود در این باکس را پاک می‌کند.
  @override
  Future<void> clearAllConfigs() async {
    print("Clearing all data from the Hive box.");
    await _box.clear();
  }
} */


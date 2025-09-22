import 'package:hive_flutter/adapters.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/vpn_model.dart';
import 'package:vpn/data/src/data_vpn_src.dart';

abstract class IDataVpnRepo {
  Future<List<VpnModel>> getAllVpns();
  Future<void> saveVpn(VpnModel vpn, String id);
  Future<void> deleteVpn(String configKey);
  Future<void> saveAllVpns(List<VpnModel> vpns);
}

class DataVpnRepo implements IDataVpnRepo {
  final IVpnDataSrc dataSource;

  // DataSource از طریق Constructor به این کلاس تزریق می شود
  DataVpnRepo({required this.dataSource});

  @override
  Future<List<VpnModel>> getAllVpns() {
    // Repository وظیفه را به DataSource محول می کند
    return dataSource.getAllVpns();
  }

  @override
  Future<void> saveVpn(VpnModel vpn, String id) {
    return dataSource.saveVpn(vpn, id);
  }

  @override
  Future<void> deleteVpn(String configKey) {
    return dataSource.deleteVpn(configKey);
  }

  @override
  Future<void> saveAllVpns(List<VpnModel> vpns) {
    return dataSource.saveAllVpns(vpns);
  }
}

final vpnRepository = DataVpnRepo(
  dataSource: DataVpnSrc(Hive.box<VpnModel>(Conf.configBox)),
);

/* import 'package:vpn/data/src/hive_src.dart';

abstract class IHiveRepo {
  Future<void> saveConfigs(String fileName, List<String> configs);
  List<String>? getConfigs(String fileName);
  Future<void> deleteConfigs(String fileName);
  Future<void> clearAllConfigs();
}

class HiveRepo implements IHiveRepo {
  final IConfigHiveDataSource configHiveDataSource;

  HiveRepo({required this.configHiveDataSource});
  @override
  Future<void> clearAllConfigs() async {
    configHiveDataSource.clearAllConfigs();
  }

  @override
  Future<void> deleteConfigs(String fileName) async {
    configHiveDataSource.deleteConfigs(fileName);
  }

  @override
  List<String>? getConfigs(String fileName) {
    return configHiveDataSource.getConfigs(fileName);
  }

  @override
  Future<void> saveConfigs(String fileName, List<String> configs) {
    return configHiveDataSource.saveConfigs(fileName, configs);
  }
}

final hiveRepo = HiveRepo(configHiveDataSource: ConfigHiveDataSource());
 */

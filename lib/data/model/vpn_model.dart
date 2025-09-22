import 'package:hive_flutter/hive_flutter.dart';

part 'vpn_model.g.dart';

@HiveType(typeId: 0)
class VpnModel {
  @HiveField(0)
  ConfigType configType;

  @HiveField(1)
  String config;

  @HiveField(2)
  String ping;

  VpnModel({
    required this.configType,
    required this.config,
    required this.ping,
  });
}

@HiveType(typeId: 1)
enum ConfigType {
  @HiveField(0)
  vless("VLESS"),

  @HiveField(1)
  vmess("VMESS"),

  @HiveField(2)
  ss("ss"),

  @HiveField(3)
  trojan('trojan');

  final String code;
  const ConfigType(this.code);
}

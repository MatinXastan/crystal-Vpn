// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VpnModelAdapter extends TypeAdapter<VpnModel> {
  @override
  final int typeId = 0;

  @override
  VpnModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VpnModel(
      configType: fields[0] as ConfigType,
      config: fields[1] as String,
      ping: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VpnModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.configType)
      ..writeByte(1)
      ..write(obj.config)
      ..writeByte(2)
      ..write(obj.ping);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VpnModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConfigTypeAdapter extends TypeAdapter<ConfigType> {
  @override
  final int typeId = 1;

  @override
  ConfigType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ConfigType.vless;
      case 1:
        return ConfigType.vmess;
      case 2:
        return ConfigType.ss;
      case 3:
        return ConfigType.trojan;
      default:
        return ConfigType.vless;
    }
  }

  @override
  void write(BinaryWriter writer, ConfigType obj) {
    switch (obj) {
      case ConfigType.vless:
        writer.writeByte(0);
        break;
      case ConfigType.vmess:
        writer.writeByte(1);
        break;
      case ConfigType.ss:
        writer.writeByte(2);
        break;
      case ConfigType.trojan:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

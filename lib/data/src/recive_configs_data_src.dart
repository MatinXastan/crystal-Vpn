import 'package:dio/dio.dart' show Dio, DioException;
import 'package:flutter/foundation.dart'; // برای ValueNotifier
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/configurations/func.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';

abstract class IReciveConfigsDataSrc {
  Future<List<String>> futureConfigs(String fileName);
  Future<List<ConfigModel>> reciveConfigAdvancedAuto();
}

class ReciveConfigsDataSrc implements IReciveConfigsDataSrc {
  final Dio httpClient;

  // ValueNotifier برای نگهداری و اعلام تغییرات لیست کانفیگ‌ها

  ReciveConfigsDataSrc({required this.httpClient});

  @override
  Future<List<String>> futureConfigs(String fileName) async {
    try {
      final response = await httpClient.get(
        'https://github.com/MatinXastan/config-fetcher/releases/download/latest/v2ray_configs.txt',
      );
      if (response.statusCode == 200 && response.data != null) {
        String content = response.data.toString();
        final lines = content.split('\n');
        final configList = lines
            .map((line) => line.trim())
            .where(
              (line) =>
                  line.isNotEmpty &&
                  (line.startsWith("vless://") ||
                      line.startsWith("vmess://") ||
                      line.startsWith("trojan://") ||
                      line.startsWith("ss://")),
            )
            .toList();

        return configList;
      } else {
        throw Exception(
          'Failed to load configs. Status: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }

  @override
  Future<List<ConfigModel>> reciveConfigAdvancedAuto() async {
    try {
      final response = await futureConfigs('v2ray_configs.txt');
      final configs = FunctionMethods.separateconfigsVmess(response);
      final models = FunctionMethods.convertConfigToModel(configs);
      return models;
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
  }
}

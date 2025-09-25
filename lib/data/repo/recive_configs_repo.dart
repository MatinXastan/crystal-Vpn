import 'package:flutter/material.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/src/recive_configs_data_src.dart';

abstract class IReciveConfigsRepo {
  Future<List<String>> futureConfigs(String fileName);

  Future<List<ConfigModel>> reciveConfigAdvancedAuto();
}

class ReciveConfigsRepo implements IReciveConfigsRepo {
  final IReciveConfigsDataSrc dataSrc;

  ReciveConfigsRepo({required this.dataSrc});

  final ValueNotifier<List<ConfigModel>> configsNotifier =
      ValueNotifier<List<ConfigModel>>([]);
  @override
  Future<List<String>> futureConfigs(String fileName) {
    return dataSrc.futureConfigs(fileName);
  }

  @override
  Future<List<ConfigModel>> reciveConfigAdvancedAuto() async {
    final models = await dataSrc.reciveConfigAdvancedAuto();

    configsNotifier.value = models;
    return models;
  }

  // متد کمکی برای پاک‌سازی Listenerها (صدا زدن از بیرون در dispose)
  void dispose() {
    configsNotifier.dispose();
  }
}

final reciveConfigsRepo = ReciveConfigsRepo(
  dataSrc: ReciveConfigsDataSrc(httpClient: Conf.dio),
);

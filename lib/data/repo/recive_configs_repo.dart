import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/src/recive_configs_data_src.dart';

abstract class IReciveConfigsRepo {
  Future<List<String>> futureConfigs(String fileName);
}

class ReciveConfigsRepo implements IReciveConfigsRepo {
  final IReciveConfigsDataSrc dataSrc;

  ReciveConfigsRepo({required this.dataSrc});

  /* final ValueNotifier<ConfigAdvancedModel> configsAdvancedAutoNotifier =
      ValueNotifier<ConfigAdvancedModel>(
        ConfigAdvancedModel(
          configs: [],
          whenFetched: DateTime.now().subtract(Duration(days: 1)),
        ),
      ); */
  @override
  Future<List<String>> futureConfigs(String fileName) {
    return dataSrc.futureConfigs(fileName);
  }

  // متد کمکی برای پاک‌سازی Listenerها (صدا زدن از بیرون در dispose)
  /* void dispose() {
    configsAdvancedAutoNotifier.dispose();
  } */
}

final reciveConfigsRepo = ReciveConfigsRepo(
  dataSrc: ReciveConfigsDataSrc(httpClient: Conf.dio),
);

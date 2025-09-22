import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/src/recive_configs_data_src.dart';

abstract class IReciveConfigsRepo {
  Future<List<String>> futureConfigs(String fileName);
}

class ReciveConfigsRepo implements IReciveConfigsRepo {
  final IReciveConfigsDataSrc dataSrc;

  ReciveConfigsRepo({required this.dataSrc});
  @override
  Future<List<String>> futureConfigs(String fileName) {
    return dataSrc.futureConfigs(fileName);
  }
}

final reciveConfigsRepo = ReciveConfigsRepo(
  dataSrc: ReciveConfigsDataSrc(httpClient: Conf.dio),
);

import 'package:vpn/data/model/config_model.dart';

class ConfigAdvancedModel {
  final List<ConfigModel> configs;
  final DateTime whenFetched;

  ConfigAdvancedModel({required this.configs, required this.whenFetched});
}

class ConfigModel {
  String config;
  int delay;

  ConfigModel({required this.config, required this.delay});

  Future<ConfigModel> copyWith({required int delay}) async {
    return ConfigModel(config: this.config, delay: delay);
  }
}

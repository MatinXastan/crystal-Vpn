import 'package:vpn/configurations/validators.dart';
import 'package:vpn/data/model/config_model.dart';

class FunctionMethods {
  FunctionMethods._();

  static List<String> separateconfigsVmess(List<String> configs) {
    // ... این متد بدون تغییر باقی می‌ماند ...
    List<String> vless = [];
    List<String> vmess = [];
    List<String> trojan = [];
    List<String> shadowSocks = [];
    List<String> tuic = [];
    List<String> unknownProtocol = [];

    for (var config in configs) {
      final protocol = Validators.getProtocolType(config);
      switch (protocol) {
        case 'VLESS':
          vless.add(config);
          break;
        case 'VMess':
          vmess.add(config);
          break;
        case 'Trojan':
          trojan.add(config);
          break;
        case 'ShadowSocks':
          shadowSocks.add(config);
          break;
        case 'Tuic':
          tuic.add(config);
          break;
        default:
          unknownProtocol.add(config);
          break;
      }
    }

    return vmess;
  }

  static List<ConfigModel> convertConfigToModel(List<String> configs) {
    List<ConfigModel> configModels = [];
    for (var config in configs) {
      configModels.add(ConfigModel(config: config, delay: 0));
    }
    return configModels;
  }
}

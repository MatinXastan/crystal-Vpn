class Validators {
  Validators._();

  static String getProtocolType(String config) {
    if (config.startsWith("vless://")) return "VLESS";
    if (config.startsWith("vmess://")) return "VMess";
    if (config.startsWith("trojan://")) return "Trojan";
    if (config.startsWith("tuic://")) return "Tuic";
    if (config.startsWith("ss://")) return "ShadowSocks";
    return "Unknown Protocol";
  }

  //TODO: کاملش کنم برای تشخیص لوکیشن
  static String getLocationType() {
    return '';
  }
}

import 'package:dio/dio.dart';

class Conf {
  Conf._();

  static const String configBox = 'config_box';
  static const String urlCheckLocation = 'https://ipleak.net/json/';
  static const String githubUser = 'MatinXastan';
  static const String repoName = 'config-fetcher';
  static const String urlTestPing =
      'http://connectivitycheck.gstatic.com/generate_204';

  static const Map<String, String> configSources = {
    'All Configs': 'v2ray_configs.txt',
    'Germany': 'Germany.txt',
    'USA': 'USA.txt',
    'Netherlands': 'Netherlands.txt',
    'Iran': 'Iran.txt',
    'UK': 'UK.txt',
    'France': 'France.txt',
    'Canada': 'Canada.txt',
    'Finland': 'Finland.txt',
    'Turkey': 'Turkey.txt',
    'Russia': 'Russia.txt',
    // ... هر کشور یا فایل دیگری که در Release دارید را اینجا اضافه کنید
  };
  static String getConfigUrl(String fileName) {
    String url =
        'https://github.com/$githubUser/$repoName/releases/latest/download/$fileName';

    return url;
  }

  static final Dio dio = Dio();
}

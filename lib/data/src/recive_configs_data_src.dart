import 'package:dio/dio.dart' show Dio, DioException;

abstract class IReciveConfigsDataSrc {
  Future<List<String>> futureConfigs(String fileName);
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
}

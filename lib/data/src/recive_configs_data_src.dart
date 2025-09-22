import 'package:dio/dio.dart' show Dio, DioException;
import 'package:vpn/configurations/conf.dart';

abstract class IReciveConfigsDataSrc {
  Future<List<String>> futureConfigs(String fileName);
}

class ReciveConfigsDataSrc implements IReciveConfigsDataSrc {
  final Dio httpClient;

  ReciveConfigsDataSrc({required this.httpClient});
  @override
  Future<List<String>> futureConfigs(String fileName) async {
    try {
      // The URL format was correct originally. The Conf.getConfigUrl wrapper is removed
      // to prevent any unintended modification of the URL.
      final response = await httpClient.get(
        'https://github.com/MatinXastan/config-fetcher/releases/download/latest/v2ray_configs.txt',
      );
      //print(response.data.toString());
      if (response.statusCode == 200 && response.data != null) {
        String content = response.data.toString();
        final lines = content.split('\n');
        // 1. Split the content by new lines.
        // 2. Trim whitespace from each line.
        // 3. Filter out empty lines and invalid configs.
        // 4. Convert the result to a new list.
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
      /* var ee = 'Network Error: ${e.message}';
      print(ee); */
      // It's better to throw an exception here instead of returning a Future.error
      // to be consistent with other error handling paths.
      throw Exception('Network Error: ${e.message}');
    } catch (e) {
      print('An unknown error occurred: $e');
      throw Exception('An unknown error occurred: $e');
    }
  }
}

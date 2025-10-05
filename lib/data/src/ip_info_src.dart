import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/ip_info_model.dart';

abstract class IIpInfoSrc {
  Future<IpInfoModel> getIpInfo();
}

class IpInfoSrc extends IIpInfoSrc {
  final Dio httpClient;
  IpInfoSrc({required this.httpClient});

  @override
  Future<IpInfoModel> getIpInfo() async {
    try {
      final response = await httpClient.get(Conf.urlCheckLocation);

      if (response.statusCode == 200 && response.data != null) {
        // اگر response.data از قبل Map است
        if (response.data is Map<String, dynamic>) {
          return IpInfoModel.fromJson(response.data as Map<String, dynamic>);
        }

        // اگر response.data یک رشته JSON است
        if (response.data is String) {
          final Map<String, dynamic> json = jsonDecode(response.data as String);
          return IpInfoModel.fromJson(json);
        }

        // اگر Dio داده‌ای مثل ResponseBody یا نوع دیگری برمی‌گرداند تلاش برای تبدیل با jsonDecode
        try {
          final Map<String, dynamic> json = (response.data is Map)
              ? Map<String, dynamic>.from(response.data as Map)
              : jsonDecode(response.data.toString()) as Map<String, dynamic>;
          return IpInfoModel.fromJson(json);
        } catch (e) {
          throw Exception('Unable to parse IP info response');
        }
      }

      throw Exception('Bad response: ${response.statusCode}');
    } on DioException catch (e) {
      // می‌توانید خطای شبکه را دقیق‌تر هندل کنید
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}

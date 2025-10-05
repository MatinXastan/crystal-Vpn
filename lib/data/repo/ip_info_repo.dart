import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/ip_info_model.dart';
import 'package:vpn/data/src/ip_info_src.dart';

abstract class IIpInfoRepo {
  Future<IpInfoModel> getIpInfo();
}

class IpInfoRepo extends IIpInfoRepo {
  final IIpInfoSrc ipInfoSrc;

  IpInfoRepo({required this.ipInfoSrc});
  @override
  Future<IpInfoModel> getIpInfo() {
    return ipInfoSrc.getIpInfo();
  }
}

final ipInfoRepo = IpInfoRepo(ipInfoSrc: IpInfoSrc(httpClient: Conf.dio));

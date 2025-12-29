// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get crystalVpn => 'Crystal VPN';

  @override
  String get superApp => '超级应用';

  @override
  String get version => '版本 1.0.0';

  @override
  String get termsAndConditions => '条款与条件';

  @override
  String get configSourceInfo => '我们从公共来源收集了最好的免费配置。';

  @override
  String get illegalUseWarning => '禁止将本应用用于非法目的。';

  @override
  String get sensitiveUseWarning => '请勿将配置用于敏感操作（如银行事务）。';

  @override
  String get acceptTerms => '我已阅读并接受条款';

  @override
  String get start => '开始';

  @override
  String get autoRedirectMsg => '如果未做出选择，将在10秒后自动跳转。';

  @override
  String get errorLabel => '错误：';

  @override
  String get countLabel => '数量：';

  @override
  String get allConfigs => '所有配置';

  @override
  String get findNewConfigs => '点击查找新配置';

  @override
  String get receivingConfigs => '正在接收配置...';

  @override
  String get pingWaitMsg => '请等待Ping测试完成。';

  @override
  String get retestNeededMsg => '配置需要重新测试。Ping测试即将开始。';

  @override
  String get bestConfigSelected => '已选择最佳配置';

  @override
  String get autoSelect => '自动选择';

  @override
  String get stop => '停止';

  @override
  String get test => '测试';

  @override
  String get selectConfigMsg => '从列表中选择一个配置';

  @override
  String get alreadyConnectedMsg => '正在连接或已连接。';

  @override
  String get invalidConfigMsg => '所选配置无效。';

  @override
  String get v2rayErrorMsg => '启动 V2Ray 时出错：';

  @override
  String get selectedServer => '已选服务器';

  @override
  String get selectConfig => '选择配置';

  @override
  String get connectionStatus => '连接状态';

  @override
  String get protocol => '协议：';

  @override
  String get error => '错误';

  @override
  String get unknown => '未知';

  @override
  String get location => '位置';

  @override
  String get refreshLocation => '刷新位置';

  @override
  String get uptime => '连接时长';

  @override
  String get myInformation => '我的信息';

  @override
  String get telegramItem => 'Telegram 频道';

  @override
  String get myTelegramChannel => '我的 Telegram 频道';

  @override
  String get githubItem => 'GitHub';

  @override
  String get myGithub => '我的 GitHub';

  @override
  String get projectItem => '项目';

  @override
  String get projectAddress => '项目地址';

  @override
  String get errorReceivingConfigs => '接收配置时出错';

  @override
  String get retry => '重试';

  @override
  String get pleaseSelectLanguage => '请选择您的语言';

  @override
  String get chooseYourLanguage => '选择您的语言';
}

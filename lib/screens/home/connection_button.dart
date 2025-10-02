import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_v2ray_client/flutter_v2ray.dart';
import 'package:provider/provider.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/data/model/config_advanced_model.dart';
import 'package:vpn/data/model/config_model.dart';
import 'package:vpn/data/repo/recive_configs_repo.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/home/bloc/home_bloc.dart';
import 'package:vpn/screens/home/custom_segmented_button.dart';
import 'package:vpn/screens/home/home_screen.dart';
import 'package:vpn/services/nav_provider.dart';
import 'package:vpn/services/v2ray_services.dart';

final double sizeConnectButtonWidget = 200;
final double sizePlayWidget = 125;
final double sizePaddingLeft = 10;

class ConnectButton extends StatefulWidget {
  // وضعیت دکمه از بیرون (از طریق HomeScreen) مشخص می‌شود
  int status;
  final ConnectionMode connectionMode;

  ConnectButton({
    super.key,
    required this.status,
    required this.connectionMode,
  });

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
  late V2ray connectV2ray;
  late V2rayService v2rayService;
  late ConfigAdvancedModel advancedAutoConfigs;
  bool _isPingingAll = false;
  final Map<String, int> _pingResults = {};
  DateTime? lastPingForAdvancedAutoConfigs;

  final List<ImageProvider> connectButtoms = [
    Assets.images.connectButtons.blue.image().image,
    Assets.images.connectButtons.yellow.image().image,
    Assets.images.connectButtons.green.image().image,
    Assets.images.connectButtons.red.image().image,
  ];
  final List<Color> colorList = [
    const Color.fromARGB(255, 3, 41, 255),
    const Color.fromARGB(255, 242, 238, 23),
    const Color.fromARGB(255, 3, 255, 41),
    const Color.fromARGB(255, 255, 3, 41),
  ];
  final List<Widget> iconWidgets = [
    Padding(
      padding: EdgeInsets.only(left: sizePaddingLeft),
      child: Assets.images.playBlue.image(
        width: sizePlayWidget,
        height: sizePlayWidget,
      ),
    ),
    Padding(
      padding: EdgeInsets.only(left: sizePaddingLeft),
      child: Assets.images.playBlue.image(
        width: sizePlayWidget,
        height: sizePlayWidget,
      ),
    ),
    Assets.images.stopGreen.image(
      width: sizePlayWidget,
      height: sizePlayWidget,
    ),
    Padding(
      padding: EdgeInsets.only(left: sizePaddingLeft),
      child: Assets.images.playRed.image(
        width: sizePlayWidget,
        height: sizePlayWidget,
      ),
    ),
  ];

  double _opacity = 1.0;
  // یک متغیر وضعیت داخلی برای نمایش داریم تا انیمیشن نرم اجرا شود
  int _displayStatus = 0;

  @override
  void initState() {
    super.initState();
    // در ابتدا، وضعیت نمایشی را با وضعیت ورودی یکی می‌کنیم
    v2rayService = context.read<V2rayService>();
    advancedAutoConfigs = context
        .read<ReciveConfigsRepo>()
        .configsAdvancedAutoNotifier
        .value;
    _displayStatus = widget.status;
    connectV2ray = V2ray(
      onStatusChanged: (status) {
        if (mounted) {
          if (status.state == Conf.connectStatus) {
            v2rayService.setV2rayState(Conf.connectStatus);
            setState(() {
              widget.status = 2;
            });
          } else if (status.state == Conf.disconnectStatus) {
            v2rayService.setV2rayState(Conf.disconnectStatus);
            setState(() {
              widget.status = 0;
            });
          }
        }
      },
    );
    _initializeConfigs();
  }

  @override
  void didUpdateWidget(ConnectButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // این متد زمانی اجرا می‌شود که ویجت از بیرون آپدیت شود
    // اگر وضعیت جدید با وضعیت قبلی فرق داشت، انیمیشن را اجرا می‌کنیم
    if (widget.status != oldWidget.status) {
      setState(() {
        _opacity = 0.0; // محو شدن با ظاهر قدیمی
      });

      // با یک تاخیر کوتاه، ظاهر جدید را جایگزین و نمایان می‌کنیم
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          // چک می‌کنیم که ویجت هنوز روی صفحه باشد
          setState(() {
            _displayStatus = widget.status; // وضعیت نمایشی را آپدیت می‌کنیم
            _opacity = 1.0; // نمایان شدن با ظاهر جدید
          });
        }
      });
    }
  }

  // متد برای مدیریت کلیک روی دکمه
  Future<void> _handleTap() async {
    // اگر در حال اتصال بود (وضعیت ۱)، کاری انجام نده
    if (widget.status == 1) {
      return;
    }

    // بر اساس وضعیت فعلی، متد مناسب از سرویس را صدا بزن
    switch (widget.status) {
      case 0: // قطع
        // v2rayService.connectAuto();
        /*  context.read<HomeBloc>().add(
          ConnectToVpnEvent(selectedMode: widget.connectionMode),
        ); */
        await _connectAutoToVpn(selectedMode: widget.connectionMode);

        break;
      case 3: // خطا
        await _connectAutoToVpn(selectedMode: widget.connectionMode);
        break;
      case 2: // وصل
        //v2rayService.disconnect();
        await _disconnect();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 400),
        child: Container(
          width: sizeConnectButtonWidget,
          height: sizeConnectButtonWidget,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                // از وضعیت نمایشی برای تعیین رنگ و آیکون استفاده می‌کنیم
                color: colorList[_displayStatus].withOpacity(0.5),
                spreadRadius: 6,
                blurRadius: 20,
              ),
            ],
            image: DecorationImage(
              image: connectButtoms[_displayStatus],
              fit: BoxFit.cover,
            ),
          ),
          alignment: Alignment.center,
          child: iconWidgets[_displayStatus],
        ),
      ),
    );
  }

  Future<void> _connectAutoToVpn({required ConnectionMode selectedMode}) async {
    if (selectedMode == ConnectionMode.advancedAuto) {
      if (advancedAutoConfigs.configs.length > 1) {
        //TODO: بایدم باشه اینجا باید یه شر بزارم  که اگه بالای 6 ساعت از آخرین دریافت کانفیگ ها میگذره هشدار بدم

        final DateTime now = DateTime.now();
        final diffrence = now.difference(
          lastPingForAdvancedAutoConfigs ??
              now.subtract(const Duration(days: 1)),
        );

        if (diffrence.inHours >= 6) {
          await _getAllPings(advancedAutoConfigs.configs);
        } else {
          await _connectToVpn(advancedAutoConfigs.configs.first);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "ارور کانفیگ های پیشرفته بهتره از کانفیگ های دستی انتخاب کنید",
            ),
          ),
        );
      }
    } else if (selectedMode == ConnectionMode.manual) {
      if (v2rayService.selectedConfig == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("یک کانفیگ را در لیست انتخاب کنید ")),
        );

        Provider.of<NavigationProvider>(
          context,
          listen: false,
        ).changeTab(BtmNavScreenIndex.config);
      } else if (v2rayService.selectedConfig != null) {
        await _connectToVpn(
          v2rayService.selectedConfig ?? ConfigModel(config: '', delay: -1),
        );
      }
    }
  }

  void _initializeConfigs() {
    //advancedAutoConfigs = List.from(configs);
    _pingResults.clear();
    for (var configModel in advancedAutoConfigs.configs) {
      _pingResults[configModel.config] = 0;
    }
  }

  //for advanced config
  Future<void> _getAllPings(List<ConfigModel> config) async {
    if (widget.status == 1) return;

    v2rayService.setIsPingingAll(true);
    v2rayService.setStatus(1);

    setState(() {
      widget.status = 1;
      _pingResults.updateAll((key, value) => 0);
    });

    try {
      await connectV2ray.initialize();
    } catch (e) {
      log('Failed to initialize V2Ray for pinging: $e');
      if (mounted) {
        setState(() => _isPingingAll = false);
      }
      return;
    }

    //final configsToPing = List<ConfigModel>.from(advancedAutoConfigs.configs);
    final configsToPing = List<ConfigModel>.from(config);
    for (final configModel in configsToPing) {
      if (widget.status == 1) break;

      if (mounted) {
        setState(() => _pingResults[configModel.config] = -3);
      }

      final result = await _getSinglePing(configModel);

      if (mounted) {
        setState(() {
          _pingResults[result.config] = result.delay;
        });
      }
    }
    _sortConfigsByPing();
  }

  Future _getSinglePing(ConfigModel configModel) async {
    final parser = _tryParse(configModel.config);
    if (parser == null) {
      return configModel.copyWith(delay: -2); // کانفیگ نامعتبر
    }
    try {
      // *** نکته کلیدی اینجاست ***
      // ما باید کانفیگ کامل را به متد بدهیم، نه لینک خام را
      final delay = await connectV2ray
          .getServerDelay(
            config: parser.getFullConfiguration(),
          ) // <-- این خط اصلاح شد
          .timeout(const Duration(seconds: 10), onTimeout: () => -1);
      return configModel.copyWith(delay: delay);
    } catch (e) {
      log("Error getting ping for ${parser.remark}: $e");
      return configModel.copyWith(delay: -1); // خطا در پینگ
    }
  }

  V2RayURL? _tryParse(String url) {
    try {
      return V2ray.parseFromURL(url);
    } catch (e) {
      log('Could not parse URL: $url. Error: $e');
      return null;
    }
  }

  Future<void> _connectToVpn(ConfigModel configModel) async {
    if (v2rayService.statuseVpn == 'CONNECTED' ||
        v2rayService.statuseVpn == 'CONNECTING') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Already connected or connecting.")),
      );
      return;
    }

    final parser = _tryParse(configModel.config);
    if (parser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("The selected config is invalid.")),
      );
      if (mounted) setState(() => widget.status = 3);
      return;
    }

    try {
      if (await connectV2ray.requestPermission()) {
        await connectV2ray.startV2Ray(
          remark: parser.remark,
          config: parser.getFullConfiguration(),
          proxyOnly: false,
        );
      }
    } catch (e) {
      log("Error starting V2Ray: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error starting V2Ray: $e")));
      if (mounted) setState(() => widget.status = 3);
    }
  }

  void _sortConfigsByPing() {
    advancedAutoConfigs.configs.sort((a, b) {
      final int pingA = _pingResults[a.config] ?? -1;
      final int pingB = _pingResults[b.config] ?? -1;
      if (pingA > 0 && pingB <= 0) return -1;
      if (pingB > 0 && pingA <= 0) return 1;
      if (pingA > 0 && pingB > 0) return pingA.compareTo(pingB);
      return 0;
    });
    v2rayService.setIsPingingAll(false);
    v2rayService.setStatus(0);

    if (mounted) {
      setState(() {
        _isPingingAll = false;
        lastPingForAdvancedAutoConfigs = DateTime.now();
      });
    }
  }

  Future<void> _disconnect() async {
    if (v2rayService.v2rayState != 'DISCONNECTED') {
      try {
        await connectV2ray.stopV2Ray();
        v2rayService.setSelectConfig(null);
      } catch (e) {
        log('Error disconnecting from V2Ray: $e');
        if (mounted) v2rayService.setStatus(3);
      }
    }
  }
}

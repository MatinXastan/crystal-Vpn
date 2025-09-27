import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/home/bloc/home_bloc.dart';
import 'package:vpn/screens/home/custom_segmented_button.dart';
import 'package:vpn/services/v2ray_services.dart';

final double sizeConnectButtonWidget = 200;
final double sizePlayWidget = 125;
final double sizePaddingLeft = 10;

class ConnectButton extends StatefulWidget {
  // وضعیت دکمه از بیرون (از طریق HomeScreen) مشخص می‌شود
  final int status;

  const ConnectButton({super.key, required this.status});

  @override
  State<ConnectButton> createState() => _ConnectButtonState();
}

class _ConnectButtonState extends State<ConnectButton> {
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
    _displayStatus = widget.status;
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
  void _handleTap() {
    final v2rayService = context.read<V2rayService>();

    // اگر در حال اتصال بود (وضعیت ۱)، کاری انجام نده
    if (widget.status == 1) {
      return;
    }

    // بر اساس وضعیت فعلی، متد مناسب از سرویس را صدا بزن
    switch (widget.status) {
      case 0: // قطع
        // v2rayService.connectAuto();
        context.read<HomeBloc>().add(
          ConnectToVpnEvent(selectedMode: ConnectionMode.advancedAuto),
        );
        break;
      case 3: // خطا
        //v2rayService.connectAuto();
        break;
      case 2: // وصل
        v2rayService.disconnect();
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
}

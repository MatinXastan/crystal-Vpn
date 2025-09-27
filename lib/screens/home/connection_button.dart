// فرض می‌کنیم که فایل مربوط
// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/home/bloc/home_bloc.dart';
import 'package:vpn/screens/home/custom_segmented_button.dart';

final double sizeConnectButtonWidget = 200;
final double sizePlayWidget = 125;
final double sizePaddingLeft = 10;

class ConnectButton extends StatefulWidget {
  int status = 0;

  ConnectButton({super.key});

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
      child: Assets.images.playYellow.image(
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

  void _changeStatus() {
    setState(() {
      _opacity = 0.0;
    });
    /* context.read<HomeBloc>().add(
      ConnectToVpnEvent(selectedMode: ConnectionMode.advancedAuto),
    ); */
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        widget.status = (widget.status + 1) % 3;
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: _changeStatus,
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: const Duration(milliseconds: 1000),
            child: Container(
              width: sizeConnectButtonWidget,
              height: sizeConnectButtonWidget,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                boxShadow: [
                  BoxShadow(
                    color: colorList[widget.status].withOpacity(
                      0.5,
                    ), // افزایش شفافیت
                    spreadRadius: 6, // افزایش شعاع پخش
                    blurRadius: 20, // افزایش محو شدگی
                  ),
                ],
                image: DecorationImage(
                  image: connectButtoms[widget.status],
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment.center,
              child: iconWidgets[widget.status],
            ),
          ),
        );
      },
    );
  }
}

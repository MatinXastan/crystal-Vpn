import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // اضافه شده برای استفاده از Bloc
import 'package:lottie/lottie.dart';
import 'package:vpn/screens/configVpnScreen/bloc/config_list_bloc.dart';
import 'package:vpn/screens/widgets/aurora_border.dart';

// مسیرهای زیر را بر اساس ساختار پروژه خودتان اصلاح کنید
// import 'package:vpn/blocs/config_list/config_list_bloc.dart';

import '../../gen/assets.gen.dart';

class EmptyConfigScreen extends StatefulWidget {
  final Function() ontap;
  const EmptyConfigScreen({super.key, required this.ontap});

  @override
  State<EmptyConfigScreen> createState() => _EmptyConfigScreenState();
}

class _EmptyConfigScreenState extends State<EmptyConfigScreen> {
  Timer? _autoClickTimer;

  @override
  void initState() {
    super.initState();
    // شروع تایمر ۵ ثانیه‌ای
    _startTimer();
  }

  void _startTimer() {
    _autoClickTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        // اگر بعد از ۵ ثانیه کلیک نشد، این ایونت اجرا می‌شود
        context.read<ConfigListBloc>().add(StartRecivingConfigsEvent());
      }
    });
  }

  @override
  void dispose() {
    // لغو تایمر برای جلوگیری از نشت حافظه
    _autoClickTimer?.cancel();
    super.dispose();
  }

  void _handleManualTap() {
    // اگر کاربر دستی کلیک کرد، تایمر خودکار لغو می‌شود
    _autoClickTimer?.cancel();
    widget.ontap();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(Assets.images.lottiefiles.empty),
        Text(
              'Click to find new configs',
              style: const TextStyle(
                fontSize: 18,
                color: Color.fromARGB(255, 130, 15, 7),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(duration: 850.ms),
        const SizedBox(height: 12),
        AuroraBorder(
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              backgroundColor: const WidgetStatePropertyAll(
                Color.fromARGB(136, 5, 255, 51),
              ),
            ),
            onPressed: _handleManualTap,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Receiving Configs',
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
            ),
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}

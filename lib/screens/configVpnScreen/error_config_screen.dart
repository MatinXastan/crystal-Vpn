import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn/l10n/app_localizations.dart';
import 'package:vpn/screens/configVpnScreen/bloc/config_list_bloc.dart';
import 'package:vpn/screens/widgets/aurora_border.dart';

import '../../gen/assets.gen.dart';

class ErrorConfigScreen extends StatefulWidget {
  final Function() onRetry; // نام تابع را به onRetry تغییر دادیم تا گویاتر باشد
  const ErrorConfigScreen({super.key, required this.onRetry});

  @override
  State<ErrorConfigScreen> createState() => _ErrorConfigScreenState();
}

class _ErrorConfigScreenState extends State<ErrorConfigScreen> {
  Timer? _autoRetryTimer;

  @override
  void initState() {
    super.initState();
    // شروع تایمر برای تلاش مجدد خودکار
    _startTimer();
  }

  void _startTimer() {
    // معمولا برای ارور زمان کمتری نسبت به حالت خالی در نظر می‌گیرند، اما اینجا روی ۸ ثانیه تنظیم شده
    _autoRetryTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        // تلاش مجدد خودکار برای دریافت کانفیگ‌ها
        context.read<ConfigListBloc>().add(StartRecivingConfigsEvent());
      }
    });
  }

  @override
  void dispose() {
    _autoRetryTimer?.cancel();
    super.dispose();
  }

  void _handleManualRetry() {
    _autoRetryTimer?.cancel();
    widget.onRetry();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // انیمیشن مربوط به ارور
        // اطمینان حاصل کنید که فایل error را در assets.gen دارید یا مسیر را اصلاح کنید
        Lottie.asset(
          Assets.images.lottiefiles.error,
          height: 200,
          repeat: false, // معمولا انیمیشن ارور یک بار اجرا می‌شود
        ),

        const SizedBox(height: 16),

        Text(
              appLocalizations.errorReceivingConfigs ??
                  "خطا در دریافت کانفیگ", // متن خطا از لوکالیزیشن
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(
                  255,
                  180,
                  20,
                  20,
                ), // رنگ قرمز برای متن خطا
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .fade(duration: 850.ms),

        const SizedBox(height: 24),

        AuroraBorder(
          // تغییر رنگ بوردر آرورا در صورت امکان، یا استفاده از همان حالت پیش‌فرض
          child: ElevatedButton(
            style: ButtonStyle(
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              // رنگ پس‌زمینه قرمز ملایم برای دکمه تلاش مجدد
              backgroundColor: const WidgetStatePropertyAll(
                Color.fromARGB(180, 255, 60, 60),
              ),
              overlayColor: WidgetStatePropertyAll(Colors.red.withOpacity(0.2)),
            ),
            onPressed: _handleManualRetry,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.refresh, color: Colors.white), // آیکون رفرش
                  const SizedBox(width: 8),
                  Text(
                    appLocalizations.retry ?? "تلاش مجدد", // متن دکمه
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const Expanded(child: SizedBox()),
      ],
    );
  }
}

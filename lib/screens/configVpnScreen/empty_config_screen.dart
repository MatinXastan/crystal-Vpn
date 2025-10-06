import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:vpn/screens/widgets/aurora_border.dart';

import '../../gen/assets.gen.dart';

class EmptyConfigScreen extends StatelessWidget {
  final Function() ontap;
  const EmptyConfigScreen({super.key, required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(Assets.images.lottiefiles.empty),
        Text(
              'No VPN config found.',
              style: TextStyle(
                fontSize: 18,
                color: const Color.fromARGB(255, 130, 15, 7),
              ),
            )
            .animate(
              // با این دستور، انیمیشن به صورت بی‌نهایت تکرار می‌شود
              onPlay: (controller) => controller.repeat(reverse: true),
            )
            // در اینجا افکت fade را با مدت زمان ۵۰۰ میلی‌ثانیه تعریف می‌کنیم
            // چون reverse فعال است، انیمیشن ابتدا در ۰.۵ ثانیه پدیدار (fade in)
            // و سپس در ۰.۵ ثانیه محو (fade out) می‌شود.
            // مجموعا یک چرخه کامل در ۱ ثانیه اتفاق می‌افتد.
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
            onPressed: ontap,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Reciving Configs',
                style: TextStyle(fontSize: 32, color: Colors.black),
              ),
            ),
          ),
        ),
        Expanded(child: SizedBox()),
      ],
    );
  }
}

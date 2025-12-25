import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ignore: must_be_immutable
class BtmNavItem extends StatelessWidget {
  IconData icon;
  Function() ontap;
  bool isSelected;

  BtmNavItem({
    super.key,
    required this.icon,
    required this.ontap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    Color colorIcon = const Color.fromARGB(255, 0, 0, 0);

    // تغییر ۱: GestureDetector والد اصلی باشد
    return GestureDetector(
      onTap: ontap,
      // تغییر ۲: این ویژگی باعث می‌شود حتی اگر روی فضای خالی کلیک شد، تاچ کار کند
      behavior: HitTestBehavior.opaque,
      child: Container(
        // تغییر ۳: استفاده از کانتینر شفاف و پدینگ داخلی برای افزایش ناحیه کلیک
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // این خط مهم است تا ارتفاع الکی زیاد نشود
          children: [
            isSelected
                ? Icon(icon, size: 32, color: colorIcon).animate().scale(
                    curve: Curves.easeInOut,
                    duration: 500.ms,
                    begin: const Offset(1, 1),
                    end: const Offset(1.2, 1.2),
                    alignment: Alignment.center,
                  )
                : Icon(icon, size: 24, color: colorIcon),
            const SizedBox(height: 2),
            Visibility(
              visible: isSelected,
              child:
                  Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(200, 234, 0, 0),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ).animate().scaleX(
                    curve: Curves.easeInOut,
                    begin: 0,
                    end: 1,
                    duration: 500.ms,
                    alignment: Alignment.center,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

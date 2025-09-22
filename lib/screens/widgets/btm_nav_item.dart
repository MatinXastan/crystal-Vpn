import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    return GestureDetector(
      onTap: ontap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSelected
                ? Icon(icon, size: 32, color: colorIcon).animate().scale(
                    curve: Curves.easeInOut,
                    duration: 500.ms,
                    begin: Offset(1, 1),
                    end: Offset(1.2, 1.2),
                    alignment: Alignment.center,
                  )
                : Icon(icon, size: 24, color: colorIcon),
            SizedBox(height: 2),
            Visibility(
              visible: isSelected,
              child:
                  Container(
                    width: 24,
                    height: 3,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(200, 234, 0, 0),
                      borderRadius: BorderRadius.circular(
                        100,
                      ), // نصف ارتفاع برای گردی کامل
                    ),
                  ).animate().scaleX(
                    curve: Curves.easeInOut,
                    /* delay: 250.ms, */
                    begin: 0, // شروع از صفر (کاملاً مخفی)
                    end: 1, // پایان در اندازه کامل
                    duration: 500.ms,
                    alignment: Alignment.center, // نقطه ثابت: سمت چپ
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

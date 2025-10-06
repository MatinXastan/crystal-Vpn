import 'dart:math';
import 'package:flutter/material.dart';

/// یک ویجت خلاقانه که یک بوردر شبیه به شفق قطبی (Aurora) ایجاد می‌کند.
///
/// این ویجت از دو گرادینت که در جهت مخالف هم می‌چرخند و یک افکت تنفس (تغییر شفافیت)
/// برای ایجاد یک جلوه‌ی بصری پویا و چشم‌نواز استفاده می‌کند.
class AuroraBorder extends StatefulWidget {
  const AuroraBorder({
    super.key,
    required this.child,
    this.borderWidth = 3.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(25)),
    this.rotationDuration = const Duration(seconds: 5),
    this.pulsateDuration = const Duration(seconds: 3),
    this.colors1,
    this.colors2,
  });

  /// ویجتی که این افکت دور آن نمایش داده می‌شود.
  final Widget child;

  /// ضخامت بوردر.
  final double borderWidth;

  /// میزان گردی گوشه‌های بوردر.
  final BorderRadius borderRadius;

  /// مدت زمان یک دور کامل چرخش گرادینت‌ها.
  final Duration rotationDuration;

  /// مدت زمان یک چرخه کامل افکت تنفس (کم و زیاد شدن شفافیت).
  final Duration pulsateDuration;

  /// لیست رنگ‌های گرادینت اول (پیش‌فرض: آبی و بنفش).
  final List<Color>? colors1;

  /// لیست رنگ‌های گرادینت دوم (پیش‌فرض: سبز و فیروزه‌ای).
  final List<Color>? colors2;

  @override
  State<AuroraBorder> createState() => _AuroraBorderState();
}

class _AuroraBorderState extends State<AuroraBorder>
    with TickerProviderStateMixin {
  late final AnimationController _rotationController;
  late final AnimationController _pulsateController;
  late final Animation<double> _pulsateAnimation;

  @override
  void initState() {
    super.initState();
    // کنترلر برای چرخش
    _rotationController = AnimationController(
      vsync: this,
      duration: widget.rotationDuration,
    )..repeat();

    // کنترلر برای افکت تنفس (Pulsate)
    _pulsateController = AnimationController(
      vsync: this,
      duration: widget.pulsateDuration,
    )..repeat(reverse: true); // به صورت رفت و برگشتی تکرار می‌شود

    // انیمیشن برای شفافیت با یک منحنی نرم (Curve)
    _pulsateAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulsateController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulsateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // رنگ‌های پیش‌فرض در صورت عدم تعیین توسط کاربر
    final defaultColors1 = [
      Colors.blue.shade300,
      Colors.purple.shade300,
      Colors.transparent,
    ];
    final defaultColors2 = [
      Colors.teal.shade200,
      Colors.cyan.shade200,
      Colors.transparent,
    ];

    return AnimatedBuilder(
      // به هر دو انیمیشن گوش می‌دهد تا در صورت تغییر، ویجت دوباره ساخته شود
      animation: Listenable.merge([_rotationController, _pulsateAnimation]),
      builder: (context, child) {
        return CustomPaint(
          painter: _AuroraBorderPainter(
            rotation: _rotationController.value,
            pulsate: _pulsateAnimation.value,
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
            colors1: widget.colors1 ?? defaultColors1,
            colors2: widget.colors2 ?? defaultColors2,
          ),
          child: Container(
            padding: EdgeInsets.all(1),
            child: ClipRRect(
              borderRadius: widget.borderRadius,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}

/// کلاس نقاش (Painter) که وظیفه رسم دو گرادینت چرخان را دارد.
class _AuroraBorderPainter extends CustomPainter {
  final double rotation;
  final double pulsate;
  final double borderWidth;
  final BorderRadius borderRadius;
  final List<Color> colors1;
  final List<Color> colors2;

  _AuroraBorderPainter({
    required this.rotation,
    required this.pulsate,
    required this.borderWidth,
    required this.borderRadius,
    required this.colors1,
    required this.colors2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = borderRadius.toRRect(rect);

    // شفافیت رنگ‌ها را بر اساس انیمیشن تنفس تنظیم می‌کند
    final pulsatingColors1 = colors1
        // ignore: deprecated_member_use
        .map((c) => c.withOpacity(c.opacity * pulsate))
        .toList();
    final pulsatingColors2 = colors2
        // ignore: deprecated_member_use
        .map((c) => c.withOpacity(c.opacity * pulsate))
        .toList();

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    // 1. رسم گرادینت اول (چرخش در جهت عقربه‌های ساعت)
    paint.shader = SweepGradient(
      colors: pulsatingColors1,
      transform: GradientRotation(rotation * 2 * pi),
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);
    canvas.drawRRect(rrect, paint);

    // 2. رسم گرادینت دوم (چرخش در خلاف جهت عقربه‌های ساعت)
    paint.shader = SweepGradient(
      colors: pulsatingColors2,
      transform: GradientRotation(
        (1 - rotation) * 2 * pi - (pi / 2),
      ), // شروع از نقطه‌ای دیگر
      stops: const [0.0, 0.5, 1.0],
    ).createShader(rect);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _AuroraBorderPainter oldDelegate) {
    // اگر هر یک از مقادیر انیمیشن تغییر کرد، دوباره نقاشی کن
    return rotation != oldDelegate.rotation || pulsate != oldDelegate.pulsate;
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/l10n/app_localizations.dart';
import 'package:vpn/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _isAccepted = false; // وضعیت چک‌باکس
  bool _showTerms = false; // آیا کارت قوانین نمایش داده شود؟

  // کنترلر انیمیشن برای نمایش نرم
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // تنظیمات انیمیشن
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // تابع بررسی وضعیت کاربر را صدا می‌زنیم
    _checkUserStatus();
  }

  /// بررسی می‌کند که آیا کاربر قبلاً قوانین را پذیرفته است یا خیر
  Future<void> _checkUserStatus() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // کلید 'is_terms_accepted' را چک می‌کنیم
    bool hasAccepted = preferences.getBool('is_terms_accepted') ?? false;

    if (hasAccepted) {
      // اگر قبلاً قبول کرده، بدون نمایش انیمیشن و قوانین، مستقیم برو به خانه
      _navigateToHome(savePrefs: false);
    } else {
      // اگر بار اول است، انیمیشن را اجرا کن و قوانین را نشان بده
      _animationController.forward();
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showTerms = true;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// تابع نویگیشن به صفحه اصلی
  /// [savePrefs]: اگر true باشد، وضعیت را در حافظه ذخیره می‌کند (برای بار اول)
  Future<void> _navigateToHome({bool savePrefs = true}) async {
    if (savePrefs) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('is_terms_accepted', true);
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    // ابعاد صفحه
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // تم آبی کریستالی (Crystal Blue)
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00C6FB), // فیروزه‌ای کریستالی روشن
              Color(0xFF005BEA), // آبی عمیق اقیانوسی
            ],
          ),
        ),
        child: Stack(
          children: [
            // بخش لوگو و عنوان (در وسط صفحه)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOutBack,
              // اگر قوانین نمایش داده شده باشد لوگو بالا می‌رود، در غیر این صورت وسط می‌ماند
              top: _showTerms ? size.height * 0.15 : size.height * 0.4,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // لوگوی برنامه (تصویر)
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15), // شفافیت شیشه‌ای
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      // تنظیم اندازه عکس
                      alignment: Alignment.center,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          70,
                        ), // نصف اندازه ظرف برای دایره کامل
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: Assets.luncherIcon.image(
                            fit: BoxFit.cover, // پر کردن محیط دایره
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      appLocalizations.superApp,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      appLocalizations.version,
                      style: TextStyle(fontSize: 14, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            // کارت قوانین (از پایین باز می‌شود)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutExpo,
              bottom: _showTerms
                  ? 0
                  : -400, // اگر فعال شد بیا بالا، وگرنه مخفی باش
              left: 0,
              right: 0,
              child: Container(
                height: size.height * 0.45, // ارتفاع کارت
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appLocalizations.termsAndConditions,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF005BEA), // رنگ عنوان متناسب با تم
                        ),
                      ),
                      const SizedBox(height: 15),
                      // باکس متن قوانین (اسکرول‌خور)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFF0F4F8,
                            ), // خاکستری خیلی روشن مایل به آبی
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.1),
                            ),
                          ),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _TermItem(
                                  text: appLocalizations.configSourceInfo,
                                ),
                                SizedBox(height: 12),
                                _TermItem(
                                  text: appLocalizations.illegalUseWarning,
                                  isWarning: true,
                                ),
                                SizedBox(height: 12),
                                _TermItem(
                                  text: appLocalizations.sensitiveUseWarning,
                                  isWarning: true,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // چک‌باکس تایید
                      Material(
                        color: Colors.transparent,
                        child: CheckboxListTile(
                          value: _isAccepted,
                          onChanged: (val) {
                            setState(() {
                              _isAccepted = val ?? false;
                            });
                          },
                          activeColor: const Color(0xFF005BEA),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            appLocalizations.acceptTerms,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // دکمه ورود
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          // تغییر مهم: اینجا صدا زدن متد نویگیشن
                          onPressed: _isAccepted
                              ? () => _navigateToHome(savePrefs: true)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(
                              0xFF005BEA,
                            ), // رنگ دکمه
                            foregroundColor: Colors.white, // رنگ متن
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[500],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: _isAccepted ? 8 : 0,
                            shadowColor: const Color(
                              0xFF005BEA,
                            ).withOpacity(0.4),
                          ),
                          child: Text(
                            appLocalizations.start,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ویجت کمکی برای نمایش هر بند از قوانین به صورت لیست بولت‌دار
class _TermItem extends StatelessWidget {
  final String text;
  final bool isWarning;

  const _TermItem({required this.text, this.isWarning = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, left: 8),
          child: Icon(
            isWarning
                ? Icons.warning_amber_rounded
                : Icons.check_circle_outline,
            size: 16,
            color: isWarning ? Colors.orange : Colors.blue,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
              fontWeight: isWarning ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn/services/local_provider.dart';
import 'package:vpn/tutorial_video_screen.dart'; // ایمپورت صفحه جدید

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // لیست زبان‌های پشتیبانی شده
    final List<Map<String, dynamic>> languages = [
      {'code': 'en', 'name': 'English', 'flag': '🇺🇸'},
      {'code': 'fa', 'name': 'فارسی', 'flag': '🇮🇷'},
      {'code': 'ru', 'name': 'Русский', 'flag': '🇷🇺'},
      {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
      {'code': 'tr', 'name': 'Türkçe', 'flag': '🇹🇷'},
    ];

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // همان گرادینت آبی کریستالی
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00C6FB), // فیروزه‌ای کریستالی روشن
              Color(0xFF005BEA), // آبی عمیق اقیانوسی
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // آیکون خوش‌آمدگویی
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.language_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                "Choose Your Language",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              const Text(
                "لطفا زبان خود را انتخاب کنید",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  fontFamily: 'Vazir',
                ),
              ),
              const SizedBox(height: 40),

              // لیست زبان‌ها
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: languages.length,
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _LanguageButton(
                        flag: lang['flag'],
                        name: lang['name'],
                        code: lang['code'],
                        onTap: () async {
                          // 1. تغییر زبان در پرووایدر
                          final provider = Provider.of<LocaleProvider>(
                            context,
                            listen: false,
                          );
                          await provider.setLocale(Locale(lang['code']));

                          // 2. هدایت به صفحه ویدیوی آموزشی (به جای اسپلش اسکرین)
                          if (context.mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TutorialVideoScreen(),
                              ),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ویجت دکمه زبان شیشه‌ای (بدون تغییر نسبت به کد اصلی شما)
class _LanguageButton extends StatelessWidget {
  final String flag;
  final String name;
  final String code;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.flag,
    required this.name,
    required this.code,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(flag, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 15),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

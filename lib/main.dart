import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:vpn/l10n/app_localizations.dart';
import 'package:vpn/language_selection.dart'; // مسیر فایل جدید
import 'package:vpn/services/local_provider.dart';
import 'package:vpn/services/nav_provider.dart';
import 'package:vpn/services/v2ray_services.dart';
import 'package:vpn/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // ایجاد نمونه‌ای از LocaleProvider برای بارگذاری زبان قبل از اجرای برنامه
  final localeProvider = LocaleProvider();
  await localeProvider.fetchLocale();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => V2rayService()),
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        // اضافه کردن پرووایدر زبان با مقدار اولیه
        ChangeNotifierProvider(create: (context) => localeProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // دریافت زبان فعلی از پرووایدر
    // استفاده از Consumer یا context.watch باعث می‌شود با تغییر زبان، کل برنامه ریلود شود
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Crystal Vpn",

      // تنظیمات زبان داینامیک
      locale: localeProvider.locale,

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'), // انگلیسی
        Locale('fa'), // فارسی
        Locale('zh'), // چینی
        Locale('ru'), // روسی
        Locale('tr'), // ترکی
      ],

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      // منطق نمایش صفحه اول:
      // اگر زبان انتخاب شده است -> اسپلش اسکرین
      // اگر زبان انتخاب نشده است -> صفحه انتخاب زبان
      home: localeProvider.isLanguageSelected
          ? const SplashScreen()
          : const LanguageSelectionScreen(),
    );
  }
}

# 🛡️ Crystal VPN

یک برنامه VPN جامع و قدرتمند برای دسترسی امن و آزاد به اینترنت، با تمرکز بر پروتکل‌های V2Ray و مجموعه‌ای غنی از کانفیگ‌های تست‌شده. این پروژه با **Flutter** توسعه یافته و تجربه‌ای بومی و روان را ارائه می‌دهد.

این اپ نه تنها یک کلاینت ساده برای اتصال به سرورها است، بلکه به‌عنوان یک **مجموعه‌دار کانفیگ‌های آماده** عمل می‌کند. کاربران می‌توانند به‌راحتی بین پروتکل‌ها و تنظیمات مختلف جابه‌جا شوند و بهترین اتصال ممکن را انتخاب کنند.

## ✨ ویژگی‌های کلیدی

- **کانفیگ‌های متنوع VPN**: دسترسی به مجموعه‌ای از کانفیگ‌های از پیش تنظیم‌شده با پروتکل‌های مختلف (V2Ray، Shadowsocks و غیره).
- **کلاینت V2Ray قدرتمند**: استفاده از هسته V2Ray برای اتصالات پایدار، امن و پرسرعت.
- **مدیریت آسان پروفایل‌ها**: انتخاب سریع کانفیگ‌ها با رابط کاربری intuitive.
- **رابط کاربری زیبا**: طراحی مدرن و کاربرپسند با Flutter، سازگار با اندروید.
- **نمایش وضعیت اتصال**: اطلاعات لحظه‌ای درباره سرعت، مصرف داده و وضعیت اتصال.

## 🚀 شروع به کار

### پیش‌نیازها
- **Flutter SDK**: نسخه 3.0.0 یا بالاتر (توصیه‌شده: 3.24.x برای بهترین سازگاری).
- **Android Studio** یا **VS Code** با پلاگین‌های Flutter و Dart.
- **JDK**: نسخه 17 یا بالاتر برای توسعه اندروید.
- یک دستگاه اندروید یا شبیه‌ساز متصل.

### نصب و اجرا
1. **کلون کردن مخزن**:
   ```bash:disable-run
   git clone https://github.com/MatinXastan/crystal-Vpn.git
   cd crystal-Vpn
   ```

2. **دریافت وابستگی‌ها**:
   ```bash
   flutter pub get
   ```

3. **اجرای پروژه**:
   ```bash
   flutter run
   ```
   (اطمینان حاصل کنید که دستگاه یا شبیه‌ساز اندروید متصل است.)

### نکات اضافی
- برای ساخت APK، از `flutter build apk --release` استفاده کنید.

## 📱 دانلود اپ
برای دانلود نسخه‌های آماده، به [صفحه Releases](https://github.com/MatinXastan/crystal-Vpn/releases) مراجعه کنید:

| معماری | لینک دانلود |
|---------|--------------|
| Universal | [![ANDROID](https://img.shields.io/badge/ANDROID-grey?style=flat-square&logo=android)] [دانلود](https://github.com/MatinXastan/crystal-Vpn/releases/download/vpn/app-release.apk) |
| arm64-v8a | [![ANDROID](https://img.shields.io/badge/ANDROID-grey?style=flat-square&logo=android)] [دانلود](https://github.com/MatinXastan/crystal-Vpn/releases/download/vpn/app-arm64-v8a-release.apk) |
| armeabi-v7a | [![ANDROID](https://img.shields.io/badge/ANDROID-grey?style=flat-square&logo=android)] [دانلود](https://github.com/MatinXastan/crystal-Vpn/releases/download/vpn/app-armeabi-v7a-release.apk) |
| x86_64 | [![ANDROID](https://img.shields.io/badge/ANDROID-grey?style=flat-square&logo=android)] [دانلود](https://github.com/MatinXastan/crystal-Vpn/releases/download/vpn/app-x86_64-release.apk) |

## 🙏 تقدیر و تشکر
بخش اصلی این پروژه، یعنی پیاده‌سازی کلاینت V2Ray، با الهام از پروژه [flutter_v2ray_client](https://github.com/amir-zr/flutter_v2ray_client) نوشته‌شده توسط **Amir-zr** انجام شده است. از زحمات ایشان در توسعه و اشتراک‌گذاری این ابزار ارزشمند صمیمانه سپاسگزاریم.

## 📄 مجوز (License)
این پروژه تحت **مجوز MIT** منتشر شده است. این مجوز به شما آزادی کامل برای استفاده، تغییر، توزیع و زیرمجموعه‌سازی کد می‌دهد. برای جزئیات بیشتر، به فایل [LICENSE](LICENSE) مراجعه کنید.

---

⭐ اگر این پروژه مفید بود، با ستاره دادن حمایت کنید!    
🐛 باگ‌ها را در [Issues](https://github.com/MatinXastan/crystal-Vpn/issues) گزارش دهید.

---

*آخرین به‌روزرسانی: اکتبر ۲۰۲۵*
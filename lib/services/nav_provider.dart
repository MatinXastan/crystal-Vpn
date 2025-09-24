import 'package:flutter/material.dart';

// کلاس ایندکس‌ها را برای دسترسی آسان اینجا می‌آوریم
class BtmNavScreenIndex {
  BtmNavScreenIndex._();
  static const home = 0;
  static const config = 1;
  static const profile = 2;
}

class NavigationProvider extends ChangeNotifier {
  // این متغیرها از MainScreen به اینجا منتقل شدند
  int _selectedIndex = BtmNavScreenIndex.home;
  final List<int> _routeHistory = [BtmNavScreenIndex.home];

  // Getterها برای دسترسی به متغیرهای خصوصی
  int get selectedIndex => _selectedIndex;
  List<int> get routeHistory => _routeHistory;

  // متدی برای تغییر تب
  void changeTab(int index) {
    _selectedIndex = index;
    // اگر کاربر روی همان تب قبلی کلیک کرد، آن را دوباره به تاریخچه اضافه نکن
    if (_routeHistory.last != index) {
      _routeHistory.add(index);
    }
    // به همه ویجت‌هایی که گوش می‌دهند اطلاع بده که وضعیت تغییر کرده است
    notifyListeners();
  }

  // متدی برای مدیریت دکمه بازگشت
  void goBack() {
    if (_routeHistory.length > 1) {
      _routeHistory.removeLast();
      _selectedIndex = _routeHistory.last;
      notifyListeners();
    }
  }
}

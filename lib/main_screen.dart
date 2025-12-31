import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn/screens/configVpnScreen/config_list_screen.dart';
import 'package:vpn/screens/home/home_screen.dart';
import 'package:vpn/screens/profile/profile_screen.dart';
import 'package:vpn/screens/widgets/btm_nav_item.dart';
import 'package:vpn/screens/widgets/glass_box.dart';
import 'package:vpn/services/nav_provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // دیگر به متغیرهای selectedIndex و _routeHistory در اینجا نیازی نیست

  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _configKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    BtmNavScreenIndex.home: _homeKey,
    BtmNavScreenIndex.config: _configKey,
    BtmNavScreenIndex.profile: _profileKey,
  };

  Future<bool> _onWillPop(NavigationProvider navProvider) async {
    // از وضعیت داخل provider استفاده می‌کنیم
    if (map[navProvider.selectedIndex]!.currentState!.canPop()) {
      map[navProvider.selectedIndex]!.currentState!.pop();
    } else if (navProvider.routeHistory.length > 1) {
      // از متد goBack در provider استفاده می‌کنیم
      navProvider.goBack();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // به نمونه‌ی NavigationProvider دسترسی پیدا می‌کنیم
    final navProvider = Provider.of<NavigationProvider>(context);

    var size = MediaQuery.of(context).size;
    double btmNavHeight = size.height * .1;

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () => _onWillPop(navProvider),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: IndexedStack(
                  // از selectedIndex در provider استفاده می‌کنیم
                  index: navProvider.selectedIndex,
                  children: [
                    Navigator(
                      key: _homeKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    ),
                    Navigator(
                      key: _configKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => ListOfConfigsScreen(),
                      ),
                    ),
                    Navigator(
                      key: _profileKey,
                      onGenerateRoute: (settings) => MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: GlassBox(
                    width: size.width,
                    height: btmNavHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        BtmNavItem(
                          icon: Icons.person,
                          // متد provider را برای تغییر تب صدا می‌زنیم
                          ontap: () =>
                              navProvider.changeTab(BtmNavScreenIndex.profile),
                          isSelected: navProvider.selectedIndex ==
                              BtmNavScreenIndex.profile,
                        ),
                        BtmNavItem(
                          icon: Icons.home,
                          ontap: () =>
                              navProvider.changeTab(BtmNavScreenIndex.home),
                          isSelected: navProvider.selectedIndex ==
                              BtmNavScreenIndex.home,
                        ),
                        BtmNavItem(
                          icon: Icons.signal_cellular_alt,
                          ontap: () =>
                              navProvider.changeTab(BtmNavScreenIndex.config),
                          isSelected: navProvider.selectedIndex ==
                              BtmNavScreenIndex.config,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // دیگر به متد btmNavOnPressed نیازی نیست
}

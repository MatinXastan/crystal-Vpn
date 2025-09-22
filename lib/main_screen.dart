import 'package:flutter/material.dart';
import 'package:vpn/screens/configVpnScreen/config_list_screen.dart';
import 'package:vpn/screens/home/home_screen.dart';
import 'package:vpn/screens/profile/profile_screen.dart';
import 'package:vpn/screens/widgets/btm_nav_item.dart';
import 'package:vpn/screens/widgets/glass_box.dart';

class BtmNavScreenIndex {
  BtmNavScreenIndex._();
  static const home = 0;
  static const config = 1;
  static const profile = 2;
}

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<int> _routeHistory = [BtmNavScreenIndex.home];

  int selectedIndex = BtmNavScreenIndex.home;
  final GlobalKey<NavigatorState> _homeKey = GlobalKey();
  final GlobalKey<NavigatorState> _configKey = GlobalKey();
  final GlobalKey<NavigatorState> _profileKey = GlobalKey();

  late final map = {
    BtmNavScreenIndex.home: _homeKey,
    BtmNavScreenIndex.config: _configKey,
    BtmNavScreenIndex.profile: _profileKey,
  };

  // map[0] => _homeKey
  // map[1] => _basketKey
  // map[2] => _profileKey

  Future<bool> _onWillPop() async {
    if (map[selectedIndex]!.currentState!.canPop()) {
      map[selectedIndex]!.currentState!.pop();
    } else if (_routeHistory.length > 1) {
      setState(() {
        _routeHistory.removeLast();
        selectedIndex = _routeHistory.last;
      });
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    double btmNavHeight = size.height * .1;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: IndexedStack(
                index: selectedIndex,
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
                      builder: (context) => const ListOfConfigsScreen(),
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
            //ui navigator buttom
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
                        ontap: () =>
                            btmNavOnPressed(index: BtmNavScreenIndex.profile),
                        isSelected: selectedIndex == BtmNavScreenIndex.profile,
                      ),
                      BtmNavItem(
                        icon: Icons.home,
                        ontap: () =>
                            btmNavOnPressed(index: BtmNavScreenIndex.home),
                        isSelected: selectedIndex == BtmNavScreenIndex.home,
                      ),
                      BtmNavItem(
                        icon: Icons.signal_cellular_alt,
                        ontap: () =>
                            btmNavOnPressed(index: BtmNavScreenIndex.config),
                        isSelected: selectedIndex == BtmNavScreenIndex.config,
                      ),
                      /* 
                      BtmNavItem(
                        iconSvgPath: Assets.svg.home,
                        /* text: "خانه", */
                        isActive: selectedIndex == BtmNavScreenIndex.home,
                        onTap: () =>
                            btmNavOnPressed(index: BtmNavScreenIndex.home),
                      ), */
                    ],
                  ),
                ),
              ),
              /* Container(
                height: btmNavHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BtmNavItem(
                      icon: Icons.person,
                      ontap: () {},
                      isSelected: selectedIndex == BtmNavScreenIndex.profile,
                    ),
                    BtmNavItem(
                      icon: Icons.home,
                      ontap: () {},
                      isSelected: selectedIndex == BtmNavScreenIndex.home,
                    ),
                    BtmNavItem(
                      icon: Icons.signal_cellular_alt, 
                      ontap: () {},
                      isSelected: selectedIndex == BtmNavScreenIndex.config,
                    ),
                    /* 
                    BtmNavItem(
                      iconSvgPath: Assets.svg.home,
                      /* text: "خانه", */
                      isActive: selectedIndex == BtmNavScreenIndex.home,
                      onTap: () =>
                          btmNavOnPressed(index: BtmNavScreenIndex.home),
                    ), */
                  ],
                ),
              ), */
            ),
          ],
        ),
      ),
    );
  }

  btmNavOnPressed({required index}) {
    setState(() {
      selectedIndex = index;
      _routeHistory.add(selectedIndex);
    });
  }
}

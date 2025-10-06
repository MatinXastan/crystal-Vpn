import 'package:flutter/material.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/widgets/glass_box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        extendBody: true,

        body: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.backgrounds.pinkBackground.image(
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: Column(
                children: [
                  SizedBox(height: 24),
                  GlassBox(
                    width: size.width / 1.1,
                    height: size.height / 1.2,
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        Text(
                          'MY INFORMATION',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        _InformationWidget(
                          tileName: 'My telegram channel',
                          name: '@MetaTechHub',
                          icon: Icons.telegram_rounded,
                          url: Conf.myChannelTelegramAddress,
                        ),
                        _CustomDivider(),
                        _InformationWidget(
                          tileName: 'My github',
                          name: 'MatinXastan',
                          icon: Icons.language,
                          url: Conf.mygithubAddress,
                        ),
                        _CustomDivider(),
                        _InformationWidget(
                          tileName: 'Project address',
                          name: 'crystal vpn',
                          icon: Icons.code,
                          url: Conf.mygithubProjectAddress,
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _InformationWidget extends StatelessWidget {
  String tileName;
  String name;
  String url;
  IconData icon;
  _InformationWidget({
    required this.tileName,
    required this.url,
    required this.name,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      child: GestureDetector(
        onTap: () => _lunchBrowse(url),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.pinkAccent, size: 52),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tileName,
                  style: TextStyle(fontSize: 20, color: Colors.black38),
                ),
                SizedBox(height: 2),
                Text(name, style: TextStyle(fontSize: 24, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _lunchBrowse(String url) async {
    Uri.parse(url);
    /* if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    } */
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Divider(height: 2, radius: BorderRadius.circular(32)),
    );
  }
}

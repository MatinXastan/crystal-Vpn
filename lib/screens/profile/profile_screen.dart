import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vpn/configurations/conf.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/l10n/app_localizations.dart';
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
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            // پس‌زمینه اصلی صورتی
            Positioned.fill(
              child: Assets.images.backgrounds.pinkBackground.image(
                fit: BoxFit.cover,
              ),
            ),

            Center(
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // باکس شیشه‌ای (GlassBox)
                  GlassBox(
                    width: size.width / 1.1,
                    height: size.height / 1.2,
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          appLocalizations.myInformation,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // آیتم تلگرام - با کلید اختصاصی برای جلوگیری از تداخل
                        _InformationWidget(
                          key: ValueKey(appLocalizations.telegramItem),
                          tileName: appLocalizations.myTelegramChannel,
                          name: '@MetaTechHub',
                          icon: Icons.telegram_rounded,
                          url: Conf.myChannelTelegramAddress,
                        ),
                        const _CustomDivider(),

                        // آیتم گیت‌هاب - با کلید اختصاصی برای جلوگیری از تداخل
                        _InformationWidget(
                          key: ValueKey(appLocalizations.githubItem),
                          tileName: appLocalizations.myGithub,
                          name: 'MatinXastan',
                          icon: Icons.language,
                          url: Conf.mygithubAddress,
                        ),
                        const _CustomDivider(),

                        // آیتم پروژه - با کلید اختصاصی برای جلوگیری از تداخل
                        _InformationWidget(
                          key: ValueKey(appLocalizations.projectItem),
                          tileName: appLocalizations.projectAddress,
                          name: 'crystal vpn',
                          icon: Icons.code,
                          url: Conf.mygithubProjectAddress,
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InformationWidget extends StatefulWidget {
  final String tileName;
  final String name;
  final String url;
  final IconData icon;

  const _InformationWidget({
    super.key,
    required this.tileName,
    required this.url,
    required this.name,
    required this.icon,
  });

  @override
  State<_InformationWidget> createState() => _InformationWidgetState();
}

class _InformationWidgetState extends State<_InformationWidget> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: GestureDetector(
        // مدیریت انیمیشن فشرده شدن
        onTapDown: (_) => setState(() => _scale = 0.95),
        onTapUp: (_) => setState(() => _scale = 1.0),
        onTapCancel: () => setState(() => _scale = 1.0),
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              // استفاده مستقیم از widget.url مربوط به همین نمونه
              onTap: () => _launchBrowse(widget.url),
              splashColor: Colors.pinkAccent.withOpacity(0.2),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(widget.icon, color: Colors.pinkAccent, size: 52),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.tileName,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black38,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // متد اختصاصی برای باز کردن لینک با ایزولاسیون کامل آدرس
  Future<void> _launchBrowse(String urlToLaunch) async {
    final String cleanUrl = urlToLaunch.trim();
    if (cleanUrl.isEmpty) return;

    final Uri uri = Uri.parse(cleanUrl);

    try {
      // ابتدا تلاش برای باز کردن در اپلیکیشن خارجی
      final bool success = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!success) {
        // در صورت عدم موفقیت، استفاده از حالت پیش‌فرض پلتفرم
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (e) {
      debugPrint('Error launching $cleanUrl: $e');
    }
  }
}

class _CustomDivider extends StatelessWidget {
  const _CustomDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Divider(height: 1, color: Colors.white.withOpacity(0.1)),
    );
  }
}

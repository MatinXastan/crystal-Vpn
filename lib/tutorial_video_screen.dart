import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/splash_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialVideoScreen extends StatefulWidget {
  const TutorialVideoScreen({super.key});

  @override
  State<TutorialVideoScreen> createState() => _TutorialVideoScreenState();
}

class _TutorialVideoScreenState extends State<TutorialVideoScreen> {
  late VideoPlayerController _controller;
  bool _isVideoInitialized = false;
  bool _hasError = false;
  bool _isAccepted = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    try {
      _controller = VideoPlayerController.asset(Assets.video.vpnInterdouce)
        ..initialize().then((_) {
          if (!mounted) return;
          setState(() {
            _isVideoInitialized = true;
            _hasError = false;
          });
          _controller.play();
          _controller.setLooping(true);
        }).catchError((error) {
          debugPrint("Error initializing video: $error");
          if (!mounted) return;
          setState(() {
            _hasError = true;
          });
        });
    } catch (e) {
      debugPrint("Exception in video setup: $e");
      setState(() {
        _hasError = true;
      });
    }
  }

  @override
  void dispose() {
    try {
      _controller.dispose();
    } catch (e) {
      debugPrint("Error disposing controller: $e");
    }
    super.dispose();
  }

  Future<void> _onConfirmAndContinue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_tutorial_seen', true);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SplashScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00C6FB),
              Color(0xFF005BEA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10), // کاهش فاصله بالا
              Text(
                appLocalizations.tutorialTitle,
                style: TextStyle(
                  fontSize: 22, // کمی کوچکتر برای دادن فضای بیشتر به ویدیو
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Vazir',
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  appLocalizations.watchVideo,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white70,
                    fontFamily: 'Vazir',
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // بخش نمایش ویدیو
              Expanded(
                child: Container(
                  width: double.infinity, // استفاده از تمام عرض
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8), // کاهش مارجین از 20 به 8
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(
                        16), // کاهش گردی گوشه‌ها برای فضای بیشتر
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Center(
                      child:
                          _buildVideoContent()), // سنتر کردن داخل کانتینر بزرگتر
                ),
              ),

              const SizedBox(height: 20),

              // بخش پایین
              Container(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // اشغال حداقل فضای ممکن
                  children: [
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
                        dense: true, // فشرده‌تر کردن لیست تایل
                        title: Text(
                          appLocalizations.videoSeenAndUnderstood,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Vazir',
                          ),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isAccepted ? _onConfirmAndContinue : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005BEA),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.grey[300],
                          disabledForegroundColor: Colors.grey[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: _isAccepted ? 5 : 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              appLocalizations.continueAction,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Vazir',
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward_rounded, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent() {
    final AppLocalizations appLocalizations = AppLocalizations.of(context)!;
    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 40),
            const SizedBox(height: 10),
            Text(
              appLocalizations.loadingError,
              style: TextStyle(color: Colors.white, fontFamily: 'Vazir'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _hasError = false;
                });
                _initializeVideo();
              },
              child: Text(appLocalizations.retry,
                  style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      );
    }

    if (_isVideoInitialized) {
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller),
            _ControlsOverlay(controller: _controller),
            VideoProgressIndicator(_controller, allowScrubbing: true),
          ],
        ),
      );
    }

    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({required this.controller});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.value.isPlaying ? controller.pause() : controller.play();
      },
      child: Stack(
        children: <Widget>[
          if (!controller.value.isPlaying)
            const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 60.0, // آیکون پلی بزرگتر
                shadows: [Shadow(blurRadius: 10, color: Colors.black)],
              ),
            ),
          Container(color: Colors.transparent),
        ],
      ),
    );
  }
}

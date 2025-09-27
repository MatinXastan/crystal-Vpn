import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/home/connection_button.dart';
import 'package:vpn/screens/widgets/glass_box.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.blue,

        body: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.backgrounds.pinkBackground.image(
                fit: BoxFit.cover,
              ),
            ),

            Center(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}

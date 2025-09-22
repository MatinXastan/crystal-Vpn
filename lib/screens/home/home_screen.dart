import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:vpn/gen/assets.gen.dart';
import 'package:vpn/screens/widgets/connection_button.dart';
import 'package:vpn/screens/widgets/glass_box.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        backgroundColor: Colors.blue,

        body: Stack(
          children: [
            Positioned.fill(
              child: Assets.images.background.image(fit: BoxFit.cover),
            ),
            //TODO: add connection button
            Center(child: ConnectButton()),
          ],
        ),
      ),
    );
  }
}

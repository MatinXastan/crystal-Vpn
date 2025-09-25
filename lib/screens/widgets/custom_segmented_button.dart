import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vpn/services/nav_provider.dart'; // و کلاس Provider را

enum ConnectionMode { manual, advancedAuto }

class MySegmentedButton extends StatefulWidget {
  const MySegmentedButton({super.key});

  @override
  State<MySegmentedButton> createState() => _MySegmentedButtonState();
}

class _MySegmentedButtonState extends State<MySegmentedButton> {
  ConnectionMode selectedMode = ConnectionMode.advancedAuto;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<ConnectionMode>(
      segments: const <ButtonSegment<ConnectionMode>>[
        ButtonSegment<ConnectionMode>(
          value: ConnectionMode.manual,
          label: Text('Manual Mode'),
          icon: Icon(Icons.pan_tool_alt_outlined),
        ),
        ButtonSegment<ConnectionMode>(
          value: ConnectionMode.advancedAuto,
          label: Text('auto vip mode'),
          icon: Icon(Icons.auto_awesome),
        ),
      ],
      selected: <ConnectionMode>{selectedMode},
      onSelectionChanged: (Set<ConnectionMode> newSelection) {
        setState(() {
          selectedMode = newSelection.first;
        });

        if (newSelection.first == ConnectionMode.manual) {
          // *** این همان خطی است که شما می‌خواستید ***
          // به provider دسترسی پیدا کرده و درخواست تغییر تب را ارسال می‌کنیم
          // listen: false مهم است چون نمی‌خواهیم این ویجت بازسازی شود
          Provider.of<NavigationProvider>(
            context,
            listen: false,
          ).changeTab(BtmNavScreenIndex.config);
        }
      },

      // استایل شما بدون تغییر باقی می‌ماند
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color.fromARGB(255, 12, 6, 173).withOpacity(0.8);
          }
          return Colors.black.withOpacity(0.3);
        }),
        foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.white;
          }
          return Colors.grey.shade300;
        }),
        side: WidgetStateProperty.all<BorderSide>(
          BorderSide(color: Colors.grey.withOpacity(0.5), width: 1.0),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:io';
import 'desktop_layout.dart';
import 'mobile_layout.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ConverterApp());
}

class ConverterApp extends StatelessWidget {
  const ConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: determinePlatform());
  }
}

Widget determinePlatform() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    return const DesktopLayout();
  } else {
    return const MobileLayout();
  }
}

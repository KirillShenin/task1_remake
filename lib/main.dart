import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1_remake/bloc/converter_bloc.dart';
import 'package:task1_remake/desktop_layout.dart';
import 'package:task1_remake/mobile_layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS || Platform.isLinux || Platform.isWindows) {
      return BlocProvider(
          create: (context) => ConverterBloc(), child: const DesktopLayout());
    } else {
      return BlocProvider(
          create: (context) => ConverterBloc(), child: const DesktopLayout());
    }
  }
}

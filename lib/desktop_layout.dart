import 'dart:async';
import 'dart:math';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:task1_remake/bloc/converter_bloc.dart';
import 'package:task1_remake/bloc/converter_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

List<String> list = <String>['txt', 'docx', 'pdf', 'doc', 'html'];

class DesktopLayout extends StatefulWidget {
  const DesktopLayout({super.key});

  @override
  DesktopLayoutState createState() => DesktopLayoutState();
}

class DesktopLayoutState extends State<DesktopLayout> {
  @override
  ConverterBloc converterBloc = ConverterBloc();
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: const Text(
              "Конвертер файлов",
              style: TextStyle(fontSize: 35),
            ),
            centerTitle: true,
          ),
          body: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/desktop.jpg"),
                    fit: BoxFit.cover)),
          ),
        ),
      ),
    );
  }
}

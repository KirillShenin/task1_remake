import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:task1_remake/bloc/converter_bloc.dart';
import 'package:task1_remake/bloc/converter_event.dart';
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
  Widget build(BuildContext context) {
    ConverterBloc converterBloc = ConverterBloc();
    return MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BlocBuilder<ConverterBloc, ConverterState>(
          bloc: converterBloc,
          builder: ((context, state) {
            return Scaffold(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Сконвертируйте ваши файлы в любой формат',
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    FloatingActionButton(onPressed: () {
                      converterBloc.add(FilePickedEvent());
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: /*GestureDetector(
                        onTap: () async {
                          BlocProvider.of<ConverterBloc>(context)
                              .add(FilePickedEvent());
                        },
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(20),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: Colors.blue,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.blue[200],
                                borderRadius: BorderRadius.circular(20)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Icon(
                                  Icons.cloud_download,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                const Text('Выберите файл',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      ),*/
                          ElevatedButton.icon(
                        onPressed: () async {
                          converterBloc.add(FilePickedEvent());
                        },
                        icon: const Icon(Icons.file_open),
                        label: const Text('Выбрать файл'),
                      ),
                    ),
                    Center(
                      child: DropdownButton<String>(
                          value: state.chosenFileExtension,
                          hint: const Text("Доступные форматы"),
                          items: state.availableExtensions
                              .map((e) => DropdownMenuItem<String>(
                                  value: e, child: Text(e)))
                              .toList(),
                          onChanged: ((value) {
                            converterBloc.add(FileExtensionPickedEvent(value!));
                          })),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

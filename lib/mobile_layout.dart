import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1_remake/button_state.dart';
import 'package:task1_remake/bloc/convert_bloc.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});
  @override
  Widget build(BuildContext context) {
    ConvertBloc converterBloc = ConvertBloc();
    bool isLoading = false;
    return BlocProvider<ConvertBloc>(
      create: (context) => ConvertBloc(),
      child: BlocBuilder<ConvertBloc, ConvertState>(
        bloc: converterBloc,
        builder: ((context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Конвертер файлов",
                style: TextStyle(fontSize: 40),
              ),
              centerTitle: true,
            ),
            backgroundColor: Colors.white,
            body: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/mobile.jpg"),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 30,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const Text(
                      'Сконвертируйте ваши файлы в любой формат',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 30,
                        horizontal: 20,
                      ),
                      child: GestureDetector(
                        onTap: () async {
                          converterBloc.add(FilePickedEvent());
                          isLoading = true;
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
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                isLoading
                                    ? const Icon(
                                        Icons.cloud_download,
                                        color: Colors.white,
                                        size: 40,
                                      )
                                    : const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                isLoading
                                    ? Text(state.chosenFileName,
                                        style: const TextStyle(
                                            fontSize: 25, color: Colors.black))
                                    : const Text('Выберите файл',
                                        style: TextStyle(
                                            fontSize: 25, color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: state.chosenExtension,
                            hint: const Text("Выберите расширение",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black)),
                            items: state.availableExtensions
                                .map((e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(e,
                                        style: const TextStyle(
                                            fontSize: 15,
                                            color: Colors.black))))
                                .toList(),
                            onChanged: ((value) {
                              converterBloc
                                  .add(FileExtensionPickedEvent(value!));
                            }),
                          ),
                          ActionButton(bloc: converterBloc, state: state),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 30,
                            ),
                            child: SizedBox(
                              height: 40,
                              child: Visibility(
                                visible: state.isLoading,
                                child: const CircularProgressIndicator(
                                  color: Colors.red,
                                  value: null,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

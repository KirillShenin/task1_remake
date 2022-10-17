import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task1_remake/button_state.dart';
import 'package:task1_remake/bloc/converter_bloc.dart';

class MobileLayout extends StatelessWidget {
  const MobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    ConverterBloc converterBloc = ConverterBloc();
    return BlocProvider<ConverterBloc>(
        create: (context) => ConverterBloc(),
        child: BlocBuilder<ConverterBloc, ConverterState>(
            bloc: converterBloc,
            builder: ((context, state) {
              return Scaffold(
                appBar: AppBar(title: const Text('Converter app')),
                backgroundColor: Colors.white,
                body: BlocListener(
                  bloc: converterBloc,
                  listener: (BuildContext context, ConverterState state) {
                    if (state.exceptionMessage.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.redAccent,
                          content: Text(state.exceptionMessage),
                          duration: const Duration(seconds: 5),
                        ),
                      );
                    }
                  },
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              width: 250,
                              height: 35,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black87),
                                  color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(2, 5, 0, 0),
                                child: Text(
                                  state.chosenFileName,
                                  textAlign: TextAlign.left,
                                  maxLines: 1,
                                ),
                              )),
                          const SizedBox(
                            width: 15,
                          ),
                          IconButton(
                            onPressed: () async {
                              converterBloc.add(FilePickedEvent());
                            },
                            icon: const Icon(Icons.file_open),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      DropdownButton<String>(
                          value: state.chosenExtension,
                          hint: const Text("Доступные форматы"),
                          items: state.availableExtensions
                              .map((e) => DropdownMenuItem<String>(
                                  value: e, child: Text(e)))
                              .toList(),
                          onChanged: ((value) {
                            converterBloc.add(FileExtensionPickedEvent(value!));
                          })),
                      const SizedBox(
                        height: 5,
                      ),
                      ActionButton(bloc: converterBloc, state: state),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 40,
                        child: Visibility(
                          visible: state.isLoading,
                          child: const CircularProgressIndicator(
                            color: Colors.blueAccent,
                            value: null,
                          ),
                        ),
                      )
                    ],
                  )),
                ),
              );
            })));
  }
}

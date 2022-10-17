import 'package:flutter/material.dart';
import 'package:task1_remake/bloc/converter_bloc.dart';
import 'package:task1_remake/bloc/converter_event.dart';
import 'package:task1_remake/bloc/converter_state.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, required this.bloc, required this.state});

  final ConverterBloc bloc;
  final ConverterState state;

  @override
  Widget build(BuildContext context) {
    switch (state.buttonState) {
      case ButtonStates.pick:
        {
          return ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.error_outline),
            label: const Text('Выберите файл'),
          );
        }
      case ButtonStates.convert:
        {
          return ElevatedButton.icon(
            onPressed: () {
              bloc.add(FileConvertEvent());
            },
            icon: const Icon(Icons.file_upload),
            label: const Text('Конвертировать'),
          );
        }
      case ButtonStates.download:
        {
          return ElevatedButton.icon(
            onPressed: () async {
              bloc.add(FileDownloadEvent());
            },
            icon: const Icon(Icons.file_download),
            label: const Text('Скачать'),
          );
        }
    }
  }
}

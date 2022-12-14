import 'package:flutter/material.dart';
import 'package:task1_remake/bloc/convert_bloc.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.bloc, required this.state});
  final ConvertBloc bloc;
  final ConvertState state;

  @override
  Widget build(BuildContext context) {
    switch (state.buttonState) {
      case ButtonStates.pick:
        {
          return ElevatedButton.icon(
            onPressed: null,
            icon: const Icon(Icons.warning),
            label: const Text('Выберите файл'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[100]),
          );
        }
      case ButtonStates.convert:
        {
          return ElevatedButton.icon(
            onPressed: () {
              bloc.add(FileConvertEvent());
            },
            icon: const Icon(Icons.file_upload),
            label: const Text('Конвертировать',
                style: TextStyle(fontSize: 25, color: Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
          );
        }
      case ButtonStates.download:
        {
          return ElevatedButton.icon(
            onPressed: () async {
              bloc.add(FileDownloadEvent());
            },
            icon: const Icon(Icons.file_download),
            label: const Text('Скачать',
                style: TextStyle(fontSize: 25, color: Colors.black)),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[200]),
          );
        }
    }
  }
}

// ignore: depend_on_referenced_packages
// ignore_for_file: avoid_print

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloudconvert_client/cloudconvert_client.dart';
import 'package:file_picker/file_picker.dart';
part 'convert_event.dart';
part 'convert_state.dart';

class ConvertBloc extends Bloc<ConvertEvent, ConvertState> {
  Client client = Client(
    apiKey:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMjUzY2ZkNjc5YzE1Y2Y5NWI0OWEwNzljZWUyYzM5ZDcxMWIxMDExY2E0NDRmNTI2MzlhNjgxYzU3NDZjYTJiNjc3M2RhNjYyZDk5ODNlYjUiLCJpYXQiOjE2NjY0MTEyNDYuNTE5MDI3LCJuYmYiOjE2NjY0MTEyNDYuNTE5MDI4LCJleHAiOjQ4MjIwODQ4NDYuNTE0NDIxLCJzdWIiOiI2MDI3OTExNCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.Nl_EdUwbMCciRqG4ER1WtbsdFyY-FGxaov8puqPrMgCos993GcPbJhX_EXVhTMmyEBMQ_R9lfKZuqazMj6pCphyfSeu7F35f-2CMmOeQ0y4HoGrO7vfcs2FXMEbHjQiFn8dNsigJO-f7H4cuT9wCb9OVaAgJxpdD6G_HL1bUnxgp3xrELowOXWHZj1pd9AFOH4iv-jgWuOPzVwlwMLuVTnh-Xjh5VA8NdpCzAl0zjeY88wqkbFPyJcpRk8zm2KH5nY7skufI17xc5AmQB3Y3ra7vANYhAKu7fxit3W7lyXr6Xwni1uE8wFsgsMBzojRmyhFCfcte_6jPdayif4QYt4P6toD3wJPixM5FPfV4xAuKSM34KmIy5kb7MmUvsd4-tq24Nw6ZDYK8dE00WlhhaL163Wx-aJMknHL2UBwk3zdZe7ZeCa4-SaoFMXG13pemT4dEN1E3YPbbL2WAU0vzWjpWSBItU9K3cQ4NAQU7s4BCGHDKmYhebXDrqMG4MZx27ywzcTTiYPQHjNEvtbU6p0cY9Z-LtZXjcl5zMsxgDXmjgzdfrJLx8OIX1amStDkdfg6ggAOzDV3fcJAwEhyQDIGGeo_mYXxFpT1_51zaLoL8ZI-WRrM9JZ3rYzE7fEJUBxk2OBI2Gjvc53q59K4gZM05yuThSuATiVH8JvQcHNg',
    baseUrls: BaseUrls.live,
  );

  ConvertBloc() : super(const ConvertState()) {
    on<FilePickedEvent>(_filePicked);
    on<FileExtensionPickedEvent>(_extensionPicked);
    on<FileConvertEvent>(_fileConvert);
    on<FileDownloadEvent>(_fileDownload);
  }

  _filePicked(
    FilePickedEvent event,
    Emitter<ConvertState> emit,
  ) async {
    FilePickerResult? result;
    String name = '0';
    int found = 0;
    try {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
      found = result!.files.first.name.indexOf('.');
      name = result.files.first.name.substring(0, found);
      emit(state.copyWith(
        chosenFilePath: result.files.first.path,
        chosenFileName: name,
        isLoading: true,
      ));
      final ConverterResult formats =
          await client.getSupportedFormats(state.chosenFilePath);
      List<String> list = formats.result;
      emit(state.copyWith(
        availableExtensions: list,
        chosenExtension: list.isNotEmpty ? list.first : null,
        buttonState: list.isNotEmpty ? ButtonStates.convert : ButtonStates.pick,
      ));
    } catch (e) {
      print(e.toString());
    }
  }

  _extensionPicked(
      FileExtensionPickedEvent event, Emitter<ConvertState> emit) async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(
      chosenExtension: event.extension,
      buttonState:
          event.extension == '' ? ButtonStates.pick : ButtonStates.convert,
    ));
  }

  _fileConvert(FileConvertEvent event, Emitter<ConvertState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      ConverterResult result = await client.postJob(
        state.chosenFilePath,
        state.chosenExtension,
      );
      emit(
        state.copyWith(
          resultUrl: result.result,
          buttonState: ButtonStates.download,
        ),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  _fileDownload(FileDownloadEvent event, Emitter<ConvertState> emit) async {
    emit(state.copyWith(isLoading: true));
    String? directory;
    try {
      directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        await client.downloadResult(
          state.resultUrl,
          state.chosenFileName,
          state.chosenExtension,
          directory,
        );
        emit(const ConvertState());
      } else {
        print('Директория не выбрана');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}

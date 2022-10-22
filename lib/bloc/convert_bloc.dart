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
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZmRiNjM3ZjkxNzdmNzQ5MWE0NDM3OWVmNjU4MDI0MWNiMzMzMWVmNjczYzgyZDVlYTQ4OTM5YmRmMDUzYzhkNTkzN2JiNzQ5YTYwOTRhMWYiLCJpYXQiOjE2NjU3MTU4MjIuOTg5NjEyLCJuYmYiOjE2NjU3MTU4MjIuOTg5NjE0LCJleHAiOjQ4MjEzODk0MjIuOTg2MDU5LCJzdWIiOiI2MDI3OTExNCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.QmIvbDJyREkQktNWLrEAMoamOch-9Z4xfy9hmRboEMqDc8l1QuKcAjKqm1AS-0XX4Y6-M_5nf-Ig94va5BBvON-CWkXh2aF2fXXVOw6-I58Uxx0q28CuxIJLl1N1-gQ_XTZHmwQ5CR2OSrRtMgIen1bRv3tkAOGQ591o3vyZlRFXTwD5rqccepuoXPMyA3C3h6ztL3PIdwA2r4KarEsbCE5fiPpk3l1HP_AMo_67DgVfJBhPRfsqtO_gWS9rv3C4Wwoev_Ywxvf7-oQiTc5S6qIipIUAS5-t5HJVl2W39nhJmFojJH8B5onxQbuXpQ9TUuV5rFe9jJKQY8xinngAvw5562B-gHJtOIVsAIOiWj9nDGCPlJCMxQha7zmlIupnfSAmJ3EsztWIcEV7Eh8lYDZwhNYStxlih64VKGwl6kyks5GE73HxPrXm8XsiqwuVBYuHkw_3HW8ZsfqhKXYdtwnRoOxs00XXlMLtXPUr1v_ei2qAweIa6BkMHkH3amFcYPpG-7TyUtbZM-IB8ekYPgna_h7ABc8HuJ78T7xRSX8haVOR0Uv85T5hTT4R4dJmQCeqSSPUg7sBRCjYvE1ADF9c4c3heHouiIHj7GApsmPt5i_mElvtJ8AeFfOLqeKu9t8fDaF981ePEv0jN2vgZQ1X_gLCBkBfWofLwlNyCDs',
    baseUrls: BaseUrls.sandbox,
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

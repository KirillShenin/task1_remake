// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloudconvert_client/cloudconvert_client.dart';
import 'package:file_picker/file_picker.dart';
part 'converter_event.dart';
part 'converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  Client client = Client(
    apiKey:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNGU4NjkwYzY0MDFmMWU1OTFiN2I0MmVmZmZmMjJmYThhMzZkMzJkMDYyOWM2MjI4NWEwMjc5OGFlY2ZmODIxNGY1NTRlOTAwY2E4ZWJlYmQiLCJpYXQiOjE2NjU3MTU4ODMuNDc2MTM5LCJuYmYiOjE2NjU3MTU4ODMuNDc2MTQsImV4cCI6NDgyMTM4OTQ4My40NzE1NDgsInN1YiI6IjYwMjc5MTE0Iiwic2NvcGVzIjpbInVzZXIucmVhZCIsInVzZXIud3JpdGUiLCJ0YXNrLnJlYWQiLCJ0YXNrLndyaXRlIiwid2ViaG9vay5yZWFkIiwid2ViaG9vay53cml0ZSIsInByZXNldC5yZWFkIiwicHJlc2V0LndyaXRlIl19.EbkJWZq6NnkL83agd1IVOVlzIbt6pHzBbNs3CDv_xtsAzlo0cy9R4VHRGNZjOkk10ZT7TbAJEgGgmexedbKydQALnsA-NkLIgmE93d14bhjoWwo8vOISRxk8VlRWutBnyk49anahMcCRaQkeAtZhQXmvydO4FKqI4mVHNdmtDqJZmeJqvf57wM-tnw4aBz71B5SeXOsedsrZz_gEaRKEjxFfUxfjTmAUPE1TXe_TQP8Qw1-hGQA1nmkEp9ltqKfc7Jk0P5avOG5tf1E1iDWz5n9ZL-YPRnTh49_WM4QizzsJXALQsY74jtuvoyp8h6rMsGuF_V79gzTEJPR1-ImmxSlIfKJY8Si9gkzpuZ2H2xPrHtWY3GWFhNQAf60MO6fI79TwcXKzmX9sCVgoOYIiCYgmmaj8jli9PMONo6gadV008YLMuZ4Ypp0mLz9fMIAx541hLAQtFe3DJ_H-EULop49c3o0U3NnBaA8WR8HIrhCy8Sh2-JW3yTClV-pzHIhmGbRs0HyvlV5rg1tBnzjPXharM2EhFgnepDW2b5IWppDU0-76khwhZtngDUeHkEhyAs13N1R2HyUdF5g7vB0FTFC-PK6ZJxeddGZ-s7NEkZA43xj738r4mmxNwNNmadsxg39iGFwVEAkvzwWORWJspcdS3sBbN8kLyZo78A3e0bI',
    baseUrls: BaseUrls.live,
  );

  ConverterBloc() : super(const ConverterState()) {
    on<FilePickedEvent>(filePicked);
    on<FileExtensionPickedEvent>(fileExtensionsPicked);
    on<FileConvertEvent>(fileConvert);
    on<FileDownloadEvent>(fileDownload);
  }

  filePicked(
    FilePickedEvent event,
    Emitter<ConverterState> emit,
  ) async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(type: FileType.any);
      if (result != null) {
        emit(state.copyWith(
          chosenFilePath: result.files.first.path,
          chosenFileName: result.files.first.name,
          isLoading: true,
        ));
        final ConverterResult formats =
            await client.getSupportedFormats(state.chosenFilePath);
        if (formats.exception == null) {
          List<String> list = formats.result;
          if (list.isNotEmpty) {
            ConverterResult result =
                await client.getConvertGroup(state.chosenFilePath, list.first);
            if (result.exception != null) {
              emit(state.copyWith(
                  exceptionMessage: result.exception!['message']));
              return;
            }
          }
          emit(state.copyWith(
            availableExtensions: list,
            chosenExtension: list.isNotEmpty ? list.first : null,
            buttonState:
                list.isNotEmpty ? ButtonStates.convert : ButtonStates.pick,
          ));
        } else {
          emit(state.copyWith(exceptionMessage: formats.exception!['message']));
        }
      }
    } catch (e) {
      emit(ConverterState(exceptionMessage: e.toString()));
    }
  }

  fileExtensionsPicked(
      FileExtensionPickedEvent event, Emitter<ConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    ConverterResult result =
        await client.getConvertGroup(state.chosenFilePath, event.extension);
    if (result.exception == null) {
    } else {
      emit(state.copyWith(exceptionMessage: result.exception!['message']));
      return;
    }
    emit(state.copyWith(
      chosenExtension: event.extension,
      buttonState:
          event.extension == '' ? ButtonStates.pick : ButtonStates.convert,
    ));
  }

  fileConvert(FileConvertEvent event, Emitter<ConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      ConverterResult result = await client.postJob(
        state.chosenFilePath,
        state.chosenExtension,
      );
      if (result.exception == null) {
        emit(
          state.copyWith(
            resultUrl: result.result,
            buttonState: ButtonStates.download,
          ),
        );
      } else {
        emit(state.copyWith(exceptionMessage: result.exception!['message']));
      }
    } catch (e) {
      emit(ConverterState(exceptionMessage: e.toString()));
    }
  }

  fileDownload(FileDownloadEvent event, Emitter<ConverterState> emit) async {
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
        emit(const ConverterState());
      } else {
        emit(state.copyWith(exceptionMessage: 'Директория не выбрана'));
      }
    } catch (e) {
      emit(ConverterState(exceptionMessage: e.toString()));
    }
  }
}

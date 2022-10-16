// ignore_for_file: avoid_print, await_only_futures
import 'package:bloc/bloc.dart';
import 'package:cloudconvert_client/cloudconvert_client.dart';
import 'package:file_picker/file_picker.dart';
import 'package:task1_remake/bloc/converter_event.dart';
import 'package:task1_remake/bloc/converter_state.dart';

class ConverterBloc extends Bloc<ConverterEvent, ConverterState> {
  Client client = Client(
    apiKey:
        'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZmRiNjM3ZjkxNzdmNzQ5MWE0NDM3OWVmNjU4MDI0MWNiMzMzMWVmNjczYzgyZDVlYTQ4OTM5YmRmMDUzYzhkNTkzN2JiNzQ5YTYwOTRhMWYiLCJpYXQiOjE2NjU3MTU4MjIuOTg5NjEyLCJuYmYiOjE2NjU3MTU4MjIuOTg5NjE0LCJleHAiOjQ4MjEzODk0MjIuOTg2MDU5LCJzdWIiOiI2MDI3OTExNCIsInNjb3BlcyI6WyJ1c2VyLnJlYWQiLCJ1c2VyLndyaXRlIiwidGFzay5yZWFkIiwidGFzay53cml0ZSIsIndlYmhvb2sucmVhZCIsIndlYmhvb2sud3JpdGUiLCJwcmVzZXQucmVhZCIsInByZXNldC53cml0ZSJdfQ.QmIvbDJyREkQktNWLrEAMoamOch-9Z4xfy9hmRboEMqDc8l1QuKcAjKqm1AS-0XX4Y6-M_5nf-Ig94va5BBvON-CWkXh2aF2fXXVOw6-I58Uxx0q28CuxIJLl1N1-gQ_XTZHmwQ5CR2OSrRtMgIen1bRv3tkAOGQ591o3vyZlRFXTwD5rqccepuoXPMyA3C3h6ztL3PIdwA2r4KarEsbCE5fiPpk3l1HP_AMo_67DgVfJBhPRfsqtO_gWS9rv3C4Wwoev_Ywxvf7-oQiTc5S6qIipIUAS5-t5HJVl2W39nhJmFojJH8B5onxQbuXpQ9TUuV5rFe9jJKQY8xinngAvw5562B-gHJtOIVsAIOiWj9nDGCPlJCMxQha7zmlIupnfSAmJ3EsztWIcEV7Eh8lYDZwhNYStxlih64VKGwl6kyks5GE73HxPrXm8XsiqwuVBYuHkw_3HW8ZsfqhKXYdtwnRoOxs00XXlMLtXPUr1v_ei2qAweIa6BkMHkH3amFcYPpG-7TyUtbZM-IB8ekYPgna_h7ABc8HuJ78T7xRSX8haVOR0Uv85T5hTT4R4dJmQCeqSSPUg7sBRCjYvE1ADF9c4c3heHouiIHj7GApsmPt5i_mElvtJ8AeFfOLqeKu9t8fDaF981ePEv0jN2vgZQ1X_gLCBkBfWofLwlNyCDs',
    baseUrls: BaseUrls.sandbox,
  );
  ConverterBloc() : super(const ConverterState()) {
    on<ConverterEvent>((event, emit) async {
      if (event is FilePickedEvent) {
        await filePicked;
      } else if (event is FileExtensionPickedEvent) {
        await fileExtensionPicked;
      } else if (event is FileDownloadEvent) {
        await fileDownload;
      } else if (event is FileConvertEvent) {
        await fileConvert;
      }
    });
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
          emit(state.copyWith(
            availableExtensions: list,
            chosenFileExtension: list.isNotEmpty ? list.first : null,
          ));
        } else {
          emit(state.copyWith());
          print(formats.exception);
        }
      }
    } catch (e) {
      print(e);
      emit(const ConverterState());
    }
  }

  fileExtensionPicked(
      FileExtensionPickedEvent event, Emitter<ConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    String group = '';
    ConverterResult result =
        await client.getConvertGroup(state.chosenFilePath, event.extension);
    if (result.exception == null) {
      group = result.result;
    } else {
      print(result.exception);
    }
    emit(state.copyWith(
      chosenFileExtension: event.extension,
    ));
  }

  fileConvert(FileConvertEvent event, Emitter<ConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      ConverterResult result = await client.postJob(
        state.chosenFilePath,
        state.chosenFileExtension,
      );
      if (result.exception == null) {
        print(result.result);
        emit(state.copyWith(
          resultUrl: result.result,
        ));
      } else {
        print(result.exception);
        emit(state.copyWith());
      }
    } catch (e) {
      print(e);
      emit(const ConverterState());
    }
  }

  // Action Button поменять
  fileDownload(FileDownloadEvent event, Emitter<ConverterState> emit) async {
    emit(state.copyWith(isLoading: true));
    String? directory;
    try {
      directory = await FilePicker.platform.getDirectoryPath();
      if (directory != null) {
        await client.downloadResult(
          state.resultUrl,
          state.chosenFileName,
          state.chosenFileExtension,
          directory,
        );
      }
    } catch (e) {
      print(e);
    } finally {
      emit(const ConverterState());
    }
  }
}

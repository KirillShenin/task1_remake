part of 'converter_bloc.dart';

enum ButtonStates { pick, convert, download }

@immutable
class ConverterState {
  final String chosenFilePath;
  final String chosenFileName;
  final String chosenExtension;
  final String outputFileName;
  final List<String> availableExtensions;
  final String resultUrl;
  final bool isLoading;
  final ButtonStates buttonState;
  final String exceptionMessage;

  const ConverterState({
    this.chosenFilePath = '',
    this.chosenFileName = '',
    this.chosenExtension = '',
    this.outputFileName = '',
    this.availableExtensions = const [],
    this.resultUrl = '',
    this.isLoading = false,
    this.buttonState = ButtonStates.pick,
    this.exceptionMessage = '',
  });

  ConverterState copyWith({
    String? chosenFilePath,
    String? chosenFileName,
    String? chosenExtension,
    String? outputFileName,
    List<String>? availableExtensions,
    String? resultUrl,
    bool isLoading = false,
    ButtonStates? buttonState,
    String exceptionMessage = '',
  }) {
    return ConverterState(
      chosenFilePath: chosenFilePath ?? this.chosenFilePath,
      chosenFileName: chosenFileName ?? this.chosenFileName,
      chosenExtension: chosenExtension ?? this.chosenExtension,
      outputFileName: outputFileName ?? this.outputFileName,
      availableExtensions: availableExtensions ?? this.availableExtensions,
      resultUrl: resultUrl ?? this.resultUrl,
      isLoading: isLoading,
      buttonState: buttonState ?? this.buttonState,
      exceptionMessage: exceptionMessage,
    );
  }
}

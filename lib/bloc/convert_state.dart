part of 'convert_bloc.dart';

enum ButtonStates { pick, convert, download }

@immutable
class ConvertState {
  final String chosenFilePath;
  final String chosenFileName;
  final String chosenExtension;
  final String outputFileName;
  final List<String> availableExtensions;
  final String resultUrl;
  final bool isLoading;
  final ButtonStates buttonState;

  const ConvertState({
    this.chosenFilePath = '',
    this.chosenFileName = '',
    this.chosenExtension = '',
    this.outputFileName = '',
    this.availableExtensions = const [],
    this.resultUrl = '',
    this.isLoading = false,
    this.buttonState = ButtonStates.pick,
  });

  ConvertState copyWith({
    String? chosenFilePath,
    String? chosenFileName,
    String? chosenExtension,
    String? outputFileName,
    List<String>? availableExtensions,
    String? resultUrl,
    bool isLoading = false,
    ButtonStates? buttonState,
  }) {
    return ConvertState(
      chosenFilePath: chosenFilePath ?? this.chosenFilePath,
      chosenFileName: chosenFileName ?? this.chosenFileName,
      chosenExtension: chosenExtension ?? this.chosenExtension,
      outputFileName: outputFileName ?? this.outputFileName,
      availableExtensions: availableExtensions ?? this.availableExtensions,
      resultUrl: resultUrl ?? this.resultUrl,
      isLoading: isLoading,
      buttonState: buttonState ?? this.buttonState,
    );
  }
}

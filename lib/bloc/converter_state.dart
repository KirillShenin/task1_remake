import 'package:flutter/material.dart';

enum ButtonStates { pick, convert, download }

@immutable
class ConverterState {
  final String chosenFilePath;
  final String chosenFileName;
  final String chosenFileExtension;
  final String outputFileName;
  final List<String> availableExtensions;
  final String resultUrl;
  final ButtonStates buttonState;
  final bool isLoading;
  final IconData groupIcon;

  const ConverterState(
      {this.chosenFilePath = '',
      this.chosenFileName = '',
      this.outputFileName = '',
      this.chosenFileExtension = '',
      this.availableExtensions = const [],
      this.resultUrl = '',
      this.buttonState = ButtonStates.pick,
      this.groupIcon = Icons.error_outline,
      this.isLoading = false});

  ConverterState copyWith({
    String? chosenFilePath,
    String? chosenFileName,
    String? outputFileName,
    String? chosenFileExtension,
    List<String>? availableExtensions,
    String? resultUrl,
    ButtonStates? buttonState,
    IconData groupIcon = Icons.error_outline,
    bool isLoading = false,
  }) {
    return ConverterState(
        chosenFilePath: chosenFilePath ?? this.chosenFilePath,
        chosenFileName: chosenFileName ?? this.chosenFileName,
        outputFileName: outputFileName ?? this.outputFileName,
        chosenFileExtension: chosenFileExtension ?? this.chosenFileExtension,
        availableExtensions: availableExtensions ?? this.availableExtensions,
        resultUrl: resultUrl ?? this.resultUrl,
        buttonState: buttonState ?? this.buttonState,
        groupIcon: groupIcon,
        isLoading: isLoading);
  }
}

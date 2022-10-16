import 'package:flutter/cupertino.dart';

@immutable
class ConverterState {
  final String chosenFilePath;
  final String chosenFileName;
  final String chosenFileExtension;
  final List<String> availableExtensions;
  final String resultUrl;
  final bool isLoading;

  const ConverterState(
      {this.chosenFilePath = '',
      this.chosenFileName = '',
      this.chosenFileExtension = '',
      this.availableExtensions = const [],
      this.resultUrl = '',
      this.isLoading = false});

  ConverterState copyWith({
    String? chosenFilePath,
    String? chosenFileName,
    String? chosenFileExtension,
    List<String>? availableExtensions,
    String? resultUrl,
    bool isLoading = false,
  }) {
    return ConverterState(
        chosenFilePath: chosenFilePath ?? this.chosenFilePath,
        chosenFileName: chosenFileName ?? this.chosenFileName,
        chosenFileExtension: chosenFileExtension ?? this.chosenFileExtension,
        availableExtensions: availableExtensions ?? this.availableExtensions,
        resultUrl: resultUrl ?? this.resultUrl,
        isLoading: isLoading);
  }
}

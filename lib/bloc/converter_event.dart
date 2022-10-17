import 'package:flutter/cupertino.dart';

@immutable
abstract class ConverterEvent {}

class FilePickedEvent extends ConverterEvent {}

class FileExtensionPickedEvent extends ConverterEvent {
  final String extension;
  FileExtensionPickedEvent(this.extension);
}

class FileNameChanged extends ConverterEvent {
  final String fileName;

  FileNameChanged(this.fileName);
}

class FileDownloadEvent extends ConverterEvent {
  FileDownloadEvent();
}

class FileConvertEvent extends ConverterEvent {}

import 'package:flutter/cupertino.dart';

@immutable
abstract class ConverterEvent {}

class FilePickedEvent extends ConverterEvent {
  FilePickedEvent();
}

class FileExtensionPickedEvent extends ConverterEvent {
  final String extension;
  FileExtensionPickedEvent(this.extension);
}

class FileDownloadEvent extends ConverterEvent {
  FileDownloadEvent();
}

class FileConvertEvent extends ConverterEvent {}

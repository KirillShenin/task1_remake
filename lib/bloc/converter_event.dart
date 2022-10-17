part of 'converter_bloc.dart';

@immutable
abstract class ConverterEvent {}

class FilePickedEvent extends ConverterEvent {}

class FileExtensionPickedEvent extends ConverterEvent {
  final String extension;

  FileExtensionPickedEvent(this.extension);
}

class FileConvertEvent extends ConverterEvent {}

class FileDownloadEvent extends ConverterEvent {}

class ExceptionCaughtEvent extends ConverterEvent {
  final String exception;

  ExceptionCaughtEvent(this.exception);
}

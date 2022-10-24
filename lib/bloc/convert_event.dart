part of 'convert_bloc.dart';

@immutable
abstract class ConvertEvent {}

class FilePickedEvent extends ConvertEvent {}

class FileExtensionPickedEvent extends ConvertEvent {
  final String extension;
  FileExtensionPickedEvent(this.extension);
}

class FileConvertEvent extends ConvertEvent {}

class FileDownloadEvent extends ConvertEvent {}

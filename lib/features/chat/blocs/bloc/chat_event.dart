part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class AudioMessageSendRequested extends ChatEvent {
  final File audioFile;

  const AudioMessageSendRequested(this.audioFile);

  @override
  List<Object> get props => [audioFile.path];
}

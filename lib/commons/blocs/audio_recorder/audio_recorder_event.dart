part of 'audio_recorder_bloc.dart';

abstract class AudioRecorderEvent extends Equatable {
  const AudioRecorderEvent();

  @override
  List<Object> get props => [];
}

class AudioRecordingUpdateRequested extends AudioRecorderEvent {
  final bool record;
  final bool done;
  final bool cancel;

  const AudioRecordingUpdateRequested({
    this.record,
    this.done,
    this.cancel,
  });

  @override
  List<Object> get props => [record, done, cancel];
}

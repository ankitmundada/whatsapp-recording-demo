part of 'audio_recorder_bloc.dart';

abstract class AudioRecorderState extends BaseState {
  const AudioRecorderState(Status status, [BaseException exception])
      : super(status, exception);
}

class AudioRecorderInitial extends AudioRecorderState {
  const AudioRecorderInitial(Status status) : super(status);
}

class AudioRecordingUpdateRequestedStatus extends AudioRecorderState {
  final AudioRecordingUpdateRequested event;
  final File recordedFile;
  const AudioRecordingUpdateRequestedStatus(
    Status status,
    this.event, {
    this.recordedFile,
    BaseException exception,
  }) : super(status, exception);
}

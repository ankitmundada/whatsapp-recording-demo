part of 'audio_player_bloc.dart';

abstract class AudioPlayerState extends BaseState {
  const AudioPlayerState(Status status, [BaseException exception])
      : super(status, exception);
}

class AudioPlayerInitial extends AudioPlayerState {
  const AudioPlayerInitial(Status status) : super(status);
}

class AudioSourceUpdateStaus extends AudioPlayerState {
  const AudioSourceUpdateStaus(Status status) : super(status);
}

class AudioPlaybackUpdateStaus extends AudioPlayerState {
  final AudioPlaybackUpdateRequested event;
  const AudioPlaybackUpdateStaus(Status status, this.event) : super(status);
}

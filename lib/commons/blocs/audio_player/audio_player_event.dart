part of 'audio_player_bloc.dart';

abstract class AudioPlayerEvent extends Equatable {
  const AudioPlayerEvent();
}

class AudioPlayerBlocInitiationRequested extends AudioPlayerEvent {
  const AudioPlayerBlocInitiationRequested();
  @override
  List<Object> get props => null;
}

class AudioSourceUpdateRequested extends AudioPlayerEvent {
  final String url;
  final String filePath;
  final String asset;

  const AudioSourceUpdateRequested({
    this.url,
    this.filePath,
    this.asset,
  });

  @override
  List<Object> get props => throw UnimplementedError();
}

class AudioPlaybackUpdateRequested extends AudioPlayerEvent {
  final bool play;
  final bool stop;

  const AudioPlaybackUpdateRequested({
    this.play,
    this.stop,
  });

  @override
  List<Object> get props => [play, stop];
}

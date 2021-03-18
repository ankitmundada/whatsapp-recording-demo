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
  final bool pause;
  final bool stop;
  final bool dispose;

  final Duration seekTo;

  final double speed;
  final double volume;

  final Duration clipFrom;
  final Duration clipTo;

  const AudioPlaybackUpdateRequested({
    this.play,
    this.pause,
    this.stop,
    this.dispose,
    this.seekTo,
    this.speed,
    this.volume,
    this.clipFrom,
    this.clipTo,
  });

  @override
  List<Object> get props =>
      [play, pause, stop, seekTo, speed, volume, clipFrom, clipTo];
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:whatsappaudio/commons/base/base_state.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final _log = Logger();
  final _player = AudioPlayer();

  bool get playing => _player.playing;
  Duration get position => _player.position;
  Stream<Duration> get positionStream =>
      _player.positionStream.where((e) => e != null);
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<bool> get playingStream =>
      _player.playingStream.where((e) => e != null);
  Stream<Duration> get durationStream => _player.durationStream;
  Stream<Duration> spacedPositionStream(Duration space) {
    return _player.createPositionStream(minPeriod: space, maxPeriod: space);
  }

  AudioSource currentAudioSource;

  AudioPlayerBloc() : super(const AudioPlayerInitial(Status.UNKNOWN));

  @override
  Future<void> close() async {
    _player.dispose();
    super.close();
  }

  @override
  Stream<AudioPlayerState> mapEventToState(
    AudioPlayerEvent event,
  ) async* {
    if (event is AudioPlayerBlocInitiationRequested) {
    } else if (event is AudioSourceUpdateRequested) {
      yield* _mapAudioSourceUpdateRequestedToState(event);
    } else if (event is AudioPlaybackUpdateRequested) {
      yield* _mapAudioPlaybackUpdateRequestedToState(event);
    }
  }

  Stream<AudioPlayerState> _mapAudioSourceUpdateRequestedToState(
      AudioSourceUpdateRequested event) async* {
    yield const AudioSourceUpdateStaus(Status.LOADING);
    try {
      if (event.url != null) {
        await _player.setUrl(event.url);
        currentAudioSource = AudioSource(event.url, AudioSourceType.URL);
      } else if (event.filePath != null) {
        currentAudioSource = AudioSource(event.filePath, AudioSourceType.FILE);
        await _player.setFilePath(event.filePath);
      } else if (event.asset != null) {
        currentAudioSource = AudioSource(event.asset, AudioSourceType.ASSET);
        await _player.setAsset(event.asset);
      }
      yield const AudioSourceUpdateStaus(Status.SUCCESS);
    } catch (e, s) {
      _log.e('Audio source could not be set', e, s);
      yield const AudioSourceUpdateStaus(Status.FAILURE);
    }
  }

  Stream<AudioPlayerState> _mapAudioPlaybackUpdateRequestedToState(
      AudioPlaybackUpdateRequested event) async* {
    yield AudioPlaybackUpdateStaus(Status.LOADING, event);
    try {
      if (event.play ?? false) {
        _player.play();
        await _player.playingStream.firstWhere((isPlaying) => isPlaying);
      } else if (event.pause ?? false) {
        await _player.pause();
      } else if (event.stop ?? false) {
        await _player.stop();
      } else if (event.dispose ?? false) {
        await _player.dispose();
      } else if (event.seekTo != null) {
        await _player.seek(event.seekTo);
      } else if (event.speed != null) {
        await _player.setSpeed(event.speed);
      } else if (event.volume != null) {
        await _player.setVolume(event.volume);
      } else if (event.clipTo != null && event.clipFrom != null) {
        await _player.setClip(start: event.clipFrom, end: event.clipTo);
      }
      yield AudioPlaybackUpdateStaus(Status.SUCCESS, event);
    } catch (e, s) {
      _log.e('Audio source could not be set', e, s);
      yield AudioPlaybackUpdateStaus(Status.FAILURE, event);
    }
  }
}

enum AudioSourceType {
  URL,
  ASSET,
  FILE,
}

class AudioSource {
  final String value;
  final AudioSourceType type;

  const AudioSource(this.value, this.type);
}

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart' as audio;
import 'package:logger/logger.dart';
import 'package:whatsappaudio/commons/base/base_exception.dart';
import 'package:whatsappaudio/commons/base/base_state.dart';
import 'package:whatsappaudio/commons/models/audio_source.dart';

part 'audio_player_event.dart';
part 'audio_player_state.dart';

class AudioPlayerBloc extends Bloc<AudioPlayerEvent, AudioPlayerState> {
  final _log = Logger();
  final _player = audio.AudioPlayer();

  bool playing(AudioSource source) =>
      currentAudioSource == source &&
      _player.playing &&
      _player.playerState.processingState == audio.ProcessingState.ready;

  Duration position(AudioSource source) =>
      currentAudioSource == source ? _player.position : 0;

  Stream<Duration> positionStream(AudioSource source) => _player.positionStream
      .where((e) => e != null && currentAudioSource == source);

  Stream<audio.PlayerState> playerStateStream(AudioSource source) =>
      _player.playerStateStream.where((event) => currentAudioSource == source);

  Stream<bool> playingStream(AudioSource source) => _player.playingStream
      .where((e) => currentAudioSource == source && e != null);

  Stream<Duration> durationStream(AudioSource source) =>
      _player.durationStream.where((event) => currentAudioSource == source);

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
      // empty init
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
      } else if (event.stop ?? false) {
        await _player.stop();
      }
      yield AudioPlaybackUpdateStaus(Status.SUCCESS, event);
    } catch (e, s) {
      _log.e('Audio source could not be set', e, s);
      yield AudioPlaybackUpdateStaus(Status.FAILURE, event);
    }
  }
}

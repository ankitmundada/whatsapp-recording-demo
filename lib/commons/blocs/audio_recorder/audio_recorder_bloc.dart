import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsappaudio/commons/base/base_exception.dart';
import 'package:whatsappaudio/commons/base/base_state.dart';
import 'package:whatsappaudio/commons/utils/app_logger.dart';
import 'package:record/record.dart';

part 'audio_recorder_event.dart';
part 'audio_recorder_state.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AudioRecorderState> {
  AudioRecorderBloc() : super(const AudioRecorderInitial(Status.UNKNOWN));

  File _recordingFile;

  Future<bool> get isRecording async => await Record.isRecording();
  File get recordingFile {
    if (_recordingFile == null) {
      _recordingFile =
          File('recording_${DateTime.now().millisecondsSinceEpoch}.aac');
    }

    return _recordingFile;
  }

  @override
  Stream<AudioRecorderState> mapEventToState(
    AudioRecorderEvent event,
  ) async* {
    if (event is AudioRecordingUpdateRequested) {
      yield* _mapAudioRecordingUpdateRequestedToState(event);
    }
  }

  /// Maps [AudioRecordingUpdateRequested] event to [AudioRecordingUpdateRequestedStatus] states
  Stream<AudioRecordingUpdateRequestedStatus>
      _mapAudioRecordingUpdateRequestedToState(
          AudioRecordingUpdateRequested event) async* {
    yield AudioRecordingUpdateRequestedStatus(Status.LOADING, event);
    try {
      bool result = await Record.hasPermission();

      if (!result)
        throw const AudioRecorderBlocException('Permission Required');

      File file;
      if (event.record) {
        await Record.start(
          path: recordingFile.absolute.path,
          encoder: AudioEncoder.AAC, // by default
        );
        file = recordingFile;
      } else if (event.done) {
        await Record.stop();
        _recordingFile = null;
        file = recordingFile;
      } else if (event.cancel) {
        await Record.stop();
        await _recordingFile.delete();
        _recordingFile = null;
      }

      yield AudioRecordingUpdateRequestedStatus(
        Status.SUCCESS,
        event,
        recordedFile: file,
      );
    } catch (e, s) {
      logger.e('_mapAudioRecordingUpdateRequestedToState failed', e, s);
      yield AudioRecordingUpdateRequestedStatus(Status.FAILURE, event,
          exception: AudioRecorderBlocException(e.toString()));
    }
  }
}

class AudioRecorderBlocException extends BaseException {
  const AudioRecorderBlocException(String message) : super(message);
}

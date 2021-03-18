import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsappaudio/commons/base/base_exception.dart';
import 'package:whatsappaudio/commons/base/base_state.dart';
import 'package:whatsappaudio/commons/utils/app_logger.dart';
import 'package:record/record.dart';

part 'audio_recorder_event.dart';
part 'audio_recorder_state.dart';

class AudioRecorderBloc extends Bloc<AudioRecorderEvent, AudioRecorderState> {
  AudioRecorderBloc() : super(const AudioRecorderInitial(Status.UNKNOWN));

  File _recordingFile;
  Directory _recordingDir;

  Future<bool> get isRecording async => await Record.isRecording();

  Future<File> get recordingFile async {
    if (_recordingFile == null) {
      _recordingFile = File(
        join((await recordingDir).absolute.path,
            'recording_${DateTime.now().millisecondsSinceEpoch}.aac'),
      );
    }

    return _recordingFile;
  }

  Future<Directory> get recordingDir async {
    if (_recordingDir == null) {
      String path = join(
        (await getApplicationDocumentsDirectory()).absolute.path,
        'recordings',
      );
      _recordingDir = Directory(path);
      if (!await _recordingDir.exists()) _recordingDir.create(recursive: true);
    }
    return _recordingDir;
  }

  Future<bool> get checkPermission async =>
      (await Record.hasPermission() ||
          (await Permission.microphone.request()) ==
              PermissionStatus.granted) &&
      ((await Permission.storage.request()) == PermissionStatus.granted);

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
      if (!(await checkPermission))
        throw const AudioRecorderBlocException('Permission Required');

      File file;
      if (event.record ?? false) {
        file = await recordingFile;
        await Record.start(
          path: file.absolute.path,
          encoder: AudioEncoder.AAC, // by default
        );
      } else if (event.done ?? false) {
        await Record.stop();
        file = await recordingFile;
        _recordingFile = null;
      } else if (event.cancel ?? false) {
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

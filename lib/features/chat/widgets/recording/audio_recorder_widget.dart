import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsappaudio/commons/blocs/audio_recorder/audio_recorder_bloc.dart';
import 'package:whatsappaudio/features/chat/widgets/recording/recording_controller_widget.dart';

class AudioRecorderWidget extends StatelessWidget {
  /// height of the recording widget
  final double height;
  const AudioRecorderWidget({
    Key key,
    this.height = 64,
  }) : super(key: key);

  AudioRecorderBloc _audioRecorderBloc(BuildContext context) =>
      BlocProvider.of<AudioRecorderBloc>(context);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: RecordingControllerWidget(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
            onRecordingInitiated: () {
              _audioRecorderBloc(context)
                  .add(const AudioRecordingUpdateRequested(record: true));
            },
            onRecordingDone: () {
              _audioRecorderBloc(context)
                  .add(const AudioRecordingUpdateRequested(done: true));
            },
            onCancel: () {
              _audioRecorderBloc(context)
                  .add(const AudioRecordingUpdateRequested(cancel: true));
            },
          ),
        ),
      ),
    );
  }
}

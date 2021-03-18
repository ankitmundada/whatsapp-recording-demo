import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsappaudio/commons/blocs/audio_player/audio_player_bloc.dart';
import 'package:whatsappaudio/commons/blocs/audio_recorder/audio_recorder_bloc.dart';
import 'package:whatsappaudio/features/chat/widgets/recording_controller_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AudioPlayerBloc()),
        BlocProvider(create: (context) => AudioRecorderBloc()),
      ],
      child: ChatScreenWidget(),
    );
  }
}

class ChatScreenWidget extends StatefulWidget {
  ChatScreenWidget({Key key}) : super(key: key);

  @override
  _ChatScreenWidgetState createState() => _ChatScreenWidgetState();
}

class _ChatScreenWidgetState extends State<ChatScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Whatsapp Recorder Demo')),
      body: const AudioRecorderWidget(),
    );
  }
}

class AudioRecorderWidget extends StatelessWidget {
  final double height;
  const AudioRecorderWidget({
    Key key,
    this.height = 64,
  }) : super(key: key);

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
            onRecordingDone: () {
              _displaySnackbar(context, 'Recording Finished!');
            },
            onCancel: () {
              _displaySnackbar(context, 'Recording Cancelled.');
            },
          ),
        ),
      ),
    );
  }

  _displaySnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

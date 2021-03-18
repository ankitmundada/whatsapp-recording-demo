import 'package:flutter/material.dart';
import 'package:whatsappaudio/features/chat/widgets/recording_controller_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whatsapp Recorder Demo'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: RecordingControllerWidget(
            maxWidth: constraints.maxWidth,
            maxHeight: constraints.maxHeight,
            onRecordingDone: () {
              displaySnackbar(context, 'Recording Finished!');
            },
            onCancel: () {
              displaySnackbar(context, 'Recording Cancelled.');
            },
          ),
        ),
      ),
    );
  }

  displaySnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

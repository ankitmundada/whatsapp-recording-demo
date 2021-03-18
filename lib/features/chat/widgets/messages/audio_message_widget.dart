import 'package:flutter/material.dart';
import 'package:whatsappaudio/features/chat/models/chat_message.dart';

class AudioMessageWidget extends StatelessWidget {
  final AudioMessage message;
  const AudioMessageWidget(this.message, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(message.audioFile.path);
  }
}

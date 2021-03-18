import 'package:flutter/material.dart';
import 'package:whatsappaudio/features/chat/models/chat_message.dart';

class TextMessageWidget extends StatelessWidget {
  final TextMessage message;
  const TextMessageWidget(this.message, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(message.text);
  }
}

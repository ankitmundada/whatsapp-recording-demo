import 'dart:io';

import 'package:whatsappaudio/features/chat/models/chat_message_type.enum.dart';

/// Base class for Chat Messages. Each subclass must have a ChatMessageType
abstract class ChatMessage {
  final DateTime creationTime;
  final ChatMessageType type;

  const ChatMessage(this.type, this.creationTime);
}

/// An Audio Message
class AudioMessage extends ChatMessage {
  final File audioFile;
  AudioMessage(this.audioFile) : super(ChatMessageType.AUDIO, DateTime.now());
}

/// A Text Message
class TextMessage extends ChatMessage {
  final String text;
  TextMessage(this.text) : super(ChatMessageType.TEXT, DateTime.now());
}

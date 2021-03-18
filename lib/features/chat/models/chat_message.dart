import 'dart:io';

import 'package:whatsappaudio/features/chat/models/chat_message_type.enum.dart';

/// Base class for Chat Messages. Each subclass must have a ChatMessageType
abstract class ChatMessage {
  final ChatMessageType type;

  const ChatMessage(this.type);
}

/// An Audio Message
class AudioMessage extends ChatMessage {
  final File audioFile;
  const AudioMessage(this.audioFile) : super(ChatMessageType.AUDIO);
}

/// A Text Message
class TextMessage extends ChatMessage {
  final String text;
  const TextMessage(this.text) : super(ChatMessageType.TEXT);
}

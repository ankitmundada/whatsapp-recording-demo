import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:whatsappaudio/commons/base/base_exception.dart';
import 'package:whatsappaudio/commons/base/base_state.dart';
import 'package:whatsappaudio/commons/utils/app_logger.dart';
import 'package:whatsappaudio/features/chat/models/chat_message.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(const ChatInitial(Status.UNKNOWN));

  List<ChatMessage> messages = <ChatMessage>[];

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is AudioMessageSendRequested) {
      yield* _mapAudioMessageSendRequestedToState(event);
    }
  }

  /// Maps [AudioMessageSendRequested] event to [MessageSendRequestedStatus] states
  Stream<MessageSendRequestedStatus> _mapAudioMessageSendRequestedToState(
      AudioMessageSendRequested event) async* {
    yield const MessageSendRequestedStatus(Status.LOADING);
    try {
      messages.add(AudioMessage(event.audioFile));

      // Simulating network call delay
      await Future.delayed(Duration(seconds: 1));
      yield const MessageSendRequestedStatus(Status.SUCCESS);
    } catch (e, s) {
      logger.e('_mapAudioMessageSendRequestedToState failed', e, s);
      yield const MessageSendRequestedStatus(Status.FAILURE);
    }
  }
}

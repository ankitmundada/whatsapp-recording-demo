part of 'chat_bloc.dart';

abstract class ChatState extends BaseState {
  const ChatState(Status status, [BaseException exception])
      : super(status, exception);
}

class ChatInitial extends ChatState {
  const ChatInitial(Status status, [BaseException exception])
      : super(status, exception);
}

class MessageSendRequestedStatus extends ChatState {
  const MessageSendRequestedStatus(Status status, [BaseException exception])
      : super(status, exception);
}

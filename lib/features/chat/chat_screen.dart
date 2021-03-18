import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:whatsappaudio/commons/base/base_state.dart';
import 'package:whatsappaudio/commons/blocs/audio_player/audio_player_bloc.dart';
import 'package:whatsappaudio/commons/blocs/audio_recorder/audio_recorder_bloc.dart';
import 'package:whatsappaudio/commons/utils/utils.dart';
import 'package:whatsappaudio/commons/widgets/stream_widget.dart';
import 'package:whatsappaudio/features/chat/blocs/bloc/chat_bloc.dart';
import 'package:whatsappaudio/features/chat/models/chat_message.dart';
import 'package:whatsappaudio/features/chat/models/chat_message_type.enum.dart';
import 'package:whatsappaudio/features/chat/widgets/messages/audio_message_widget.dart';
import 'package:whatsappaudio/features/chat/widgets/messages/text_message_widget.dart';
import 'package:whatsappaudio/features/chat/widgets/recording/audio_recorder_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatBloc()),
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
  AudioRecorderBloc _audioRecorderBloc;
  ChatBloc _chatBloc;

  @override
  void initState() {
    super.initState();

    _chatBloc = BlocProvider.of<ChatBloc>(context);
    _audioRecorderBloc = BlocProvider.of<AudioRecorderBloc>(context);

    _audioRecorderBloc.stream.listen((state) {
      if (state is AudioRecordingUpdateRequestedStatus &&
          state.status == Status.SUCCESS) {
        if (state.event.done ?? false) {
          // recording finished, so add send message event to chat bloc
          _chatBloc.add(AudioMessageSendRequested(state.recordedFile));
        } else if (state.event.cancel ?? false) {
          displaySnackbar(context, 'Recording Cancelled');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Whatsapp Recorder Demo')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          messages(context),
          const AudioRecorderWidget(),
        ],
      ),
    );
  }

  Widget messages(BuildContext context) {
    return StreamWidget(
      stream: _chatBloc.stream.whereType<MessageSendRequestedStatus>(),
      successBuilder: (context) => ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          ChatMessage message = _chatBloc.messages[index];
          return message.type == ChatMessageType.TEXT
              ? TextMessageWidget(message)
              : AudioMessageWidget(message);
        },
        separatorBuilder: (context, index) => const Divider(),
        itemCount: _chatBloc.messages.length,
      ),
    );
  }
}

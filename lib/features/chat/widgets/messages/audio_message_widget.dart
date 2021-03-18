import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' as audio;
import 'package:time_formatter/time_formatter.dart';
import 'package:whatsappaudio/commons/blocs/audio_player/audio_player_bloc.dart';
import 'package:whatsappaudio/commons/models/audio_source.dart';
import 'package:whatsappaudio/features/chat/models/chat_message.dart';

class AudioMessageWidget extends StatefulWidget {
  final AudioMessage message;
  const AudioMessageWidget(this.message, {Key key}) : super(key: key);

  @override
  _AudioMessageWidgetState createState() => _AudioMessageWidgetState();
}

class _AudioMessageWidgetState extends State<AudioMessageWidget> {
  AudioPlayerBloc _audioPlayerBloc;
  AudioSource source;

  @override
  void initState() {
    super.initState();
    _audioPlayerBloc = BlocProvider.of<AudioPlayerBloc>(context);
    source = AudioSource(
        widget.message.audioFile.absolute.path, AudioSourceType.FILE);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/avatar.png'),
                ),
                const VerticalDivider(),
                Expanded(child: progressBar(context)),
                playPauseButton(context),
              ],
            ),
            Text(
                formatTime(widget.message.creationTime.millisecondsSinceEpoch)),
          ],
        ),
      ),
    );
  }

  Widget playPauseButton(BuildContext context) {
    return StreamBuilder<audio.PlayerState>(
      stream: _audioPlayerBloc.playerStateStream(
          source), // ensure that button updates on playback state changes
      builder:
          (BuildContext context, AsyncSnapshot<audio.PlayerState> snapshot) {
        return IconButton(
          onPressed: () {
            if (!_audioPlayerBloc.playing(source)) {
              _audioPlayerBloc.add(
                AudioSourceUpdateRequested(
                    filePath: widget.message.audioFile.absolute.path),
              );
              _audioPlayerBloc
                  .add(const AudioPlaybackUpdateRequested(play: true));
            } else
              _audioPlayerBloc
                  .add(const AudioPlaybackUpdateRequested(stop: true));
          },
          icon: Icon(_audioPlayerBloc.playing(source)
              ? Icons.pause
              : Icons.play_arrow),
        );
      },
    );
  }

  Widget progressBar(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final double maxWidth = constraints.maxWidth;
      return Stack(
        children: [
          trackPad(context),
          currentPositionBar(context, maxWidth),
        ],
      );
    });
  }

  Widget currentPositionBar(BuildContext context, double maxWidth) {
    return StreamBuilder(
      stream: _audioPlayerBloc.durationStream(source),
      builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
        if (snapshot.hasData) {
          final int audioLengthInMillis = snapshot.data.inMilliseconds;
          return StreamBuilder<Duration>(
            stream: _audioPlayerBloc.positionStream(source),
            initialData: const Duration(),
            builder: (context, snapshot) {
              final int currentAudioPositionInMillis =
                  snapshot.data.inMilliseconds;
              return Positioned(
                left: maxWidth *
                    currentAudioPositionInMillis /
                    audioLengthInMillis,
                child: Container(
                  width: 4,
                  height: 32,
                  color: Colors.black,
                ),
              );
            },
          );
        } else
          return Container();
      },
    );
  }

  Widget trackPad(BuildContext context) {
    return Container(
      height: 32,
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:whatsappaudio/features/chat/widgets/animated_mic_button.dart';
import 'package:whatsappaudio/features/chat/widgets/animated_recording_strip.dart';

class RecordingControllerWidget extends StatefulWidget {
  final double buttonUpperScale;
  final double maxWidth;
  final double maxHeight;
  final Function onCancel;

  final Function onRecordingDone;
  RecordingControllerWidget({
    Key key,
    @required this.onRecordingDone,
    this.maxWidth,
    this.maxHeight,
    this.buttonUpperScale = 2.0,
    this.onCancel,
  }) : super(key: key);

  @override
  _RecordingControllerWidgetState createState() =>
      _RecordingControllerWidgetState();
}

class _RecordingControllerWidgetState extends State<RecordingControllerWidget>
    with TickerProviderStateMixin {
  AnimationController _controller;
  double stripContainerPadding;
  double micContainerPadding;

  bool isRecordingCancelled = false;

  @override
  void initState() {
    super.initState();

    stripContainerPadding = 0;
    micContainerPadding = 0;

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      lowerBound: 0,
      upperBound: 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: recordingStripWithPadding(context),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: _controller,
            child: micButtonWithPadding(context),
            builder: (context, child) =>
                Transform.translate(offset: getMicButtonOffset(), child: child),
          ),
        ),
      ],
    );
  }

  initForwardAnimation() {
    setState(() {
      _controller.animateTo(1.0, curve: Curves.elasticOut);
    });
  }

  initReverseAnimation() {
    setState(() {
      _controller.animateBack(0.0, curve: Curves.bounceOut);
    });
  }

  void resetPaddings() {
    setState(() {
      stripContainerPadding = 0;
      micContainerPadding = 0;
    });
  }

  void updatePaddings(LongPressMoveUpdateDetails details) {
    setState(() {
      stripContainerPadding = -details.localOffsetFromOrigin.dx;
      micContainerPadding = stripContainerPadding;
    });
  }

  void onLongPressStart(LongPressStartDetails details) {
    isRecordingCancelled = false;
    initForwardAnimation();
  }

  void onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (details.localOffsetFromOrigin.dx < 0) updatePaddings(details);

    if (!isRecordingCancelled && stripContainerPadding > widget.maxWidth / 2) {
      isRecordingCancelled = true;
      initReverseAnimation();
      resetPaddings();
      // Cancel the recording
      // call onCancel
      if (widget.onCancel != null) widget.onCancel();
    }
  }

  void onLongPressEnd(LongPressEndDetails details) {
    resetPaddings();
    initReverseAnimation();
    // onRecordingDone Callback
    if (widget.onRecordingDone != null && !isRecordingCancelled)
      widget.onRecordingDone();
  }

  Offset getMicButtonOffset() {
    return Offset(
        _controller.status == AnimationStatus.reverse
            ? -1 * micContainerPadding
            : 0,
        0);
  }

  double getRecordingStripWidth() {
    return _controller.status == AnimationStatus.reverse
        ? 0
        : widget.maxWidth - stripContainerPadding;
  }

  Widget recordingStripWithPadding(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: stripContainerPadding),
      child: AnimatedRecordingStrip(
        controller: _controller,
        maxWidth: getRecordingStripWidth(),
        maxHeight: widget.maxHeight,
      ),
    );
  }

  Widget micButtonWithPadding(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: micContainerPadding),
      child: GestureDetector(
        onLongPressStart: onLongPressStart,
        onLongPressEnd: onLongPressEnd,
        onLongPressMoveUpdate: onLongPressMoveUpdate,
        child: AnimatedMicButton(
          controller: _controller,
          buttonUpperScale: widget.buttonUpperScale,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AnimatedRecordingStrip extends StatefulWidget {
  final AnimationController controller;
  final double maxWidth;
  final double maxHeight;
  AnimatedRecordingStrip(
      {Key key, this.controller, this.maxWidth, this.maxHeight})
      : super(key: key);

  @override
  _AnimatedRecordingStripState createState() => _AnimatedRecordingStripState();
}

class _AnimatedRecordingStripState extends State<AnimatedRecordingStrip> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.controller,
      child: ClipRRect(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.all(Radius.circular(32))),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: const Icon(Icons.mic, color: Colors.red),
                  flex: 1,
                ),
                Expanded(
                  child: Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.grey,
                    child: Text(
                      '< Slide to Unlock',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            ),
          ),
        ),
      ),
      builder: (context, child) => SizedBox(
        width: widget.controller.value * widget.maxWidth,
        height: widget.maxHeight,
        child: child,
      ),
    );
  }
}

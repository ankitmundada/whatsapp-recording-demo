import 'package:flutter/material.dart';

class AnimatedMicButton extends StatelessWidget {
  final AnimationController controller;
  final double buttonUpperScale;
  const AnimatedMicButton({Key key, this.controller, this.buttonUpperScale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: const DecoratedMicIcon(),
      builder: (context, child) => Transform.scale(
        scale: 1.0 + controller.value * (buttonUpperScale - 1.0),
        child: child,
      ),
    );
  }
}

class DecoratedMicIcon extends StatelessWidget {
  const DecoratedMicIcon({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          Icons.mic,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

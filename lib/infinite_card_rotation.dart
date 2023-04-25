library infinite_card_rotation;

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum CardFlipDirection {
  vertical,
  horizontal,
}

class FlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  ///
  /// Speed in milliseconds at which the cards with rotate
  ///
  final int speed;

  ///
  /// Direct of the rotation
  ///
  final CardFlipDirection direction;

  ///
  /// Function called when card is Flipped
  ///
  final VoidCallback? onFlip;

  ///
  /// Function called when card flip is completed
  ///
  final VoidCallback? onFlipDone;

  ///
  /// No of times the card is flipped
  ///
  final double flipCount;

  ///
  /// card is flipped infinite times
  ///
  final bool isInfinite;
  final Alignment alignment;

  const FlipCard({
    Key? key,
    required this.front,
    required this.back,
    this.speed = 250,
    this.onFlip,
    this.onFlipDone,
    this.isInfinite = false,
    this.direction = CardFlipDirection.horizontal,
    this.alignment = Alignment.center,
    this.flipCount = 1,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? _firstRotation;
  Animation<double>? _secondRotation;

  late bool isFront;
  late double flipCount;

  @override
  void initState() {
    super.initState();

    ///
    ///
    /// Initialize the late arguments in the init state
    ///
    ///
    isFront = true;
    flipCount = widget.flipCount;
    controller = AnimationController(
      value: isFront ? 0.0 : 1.0,
      duration: Duration(milliseconds: widget.speed),
      vsync: this,
    );

    ///
    ///
    /// First rotation Clockwise
    ///
    ///
    _firstRotation = TweenSequence(
      [
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.easeIn)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller!);

    ///
    ///
    /// Second rotation Clockwise
    ///
    ///
    _secondRotation = TweenSequence(
      [
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.easeOut)),
          weight: 50.0,
        ),
      ],
    ).animate(controller!);
  }

  /// Flip the card
  Future<void> flipCard() async {
    if (!mounted) return;

    if (widget.isInfinite) {
      widget.onFlip?.call();
      final animation = isFront ? controller!.forward() : controller!.reverse();
      animation.whenComplete(() {
        isFront = !isFront;
        flipCard();
      });
      return;
    }
    widget.onFlip?.call();

    controller!.duration = Duration(milliseconds: widget.speed);

    if (flipCount > 0) {
      final animation = isFront ? controller!.forward() : controller!.reverse();
      flipCount--;
      animation.whenComplete(() {
        isFront = !isFront;
        if (flipCount > 0) {
          flipCard();
        } else {
          flipCount = widget.flipCount;
        }
      });
    }

    ///
    /// If FLIP count reaches 0 call OnFlipDone
    ///
    if (flipCount <= 0) {
      widget.onFlipDone?.call();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final child = Stack(
      alignment: widget.alignment,
      fit: StackFit.passthrough,
      children: <Widget>[
        _buildCard(front: true),
        _buildCard(front: false),
      ],
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.flipCount == 0 ? null : flipCard,
      child: child,
    );
  }

  Widget _buildCard({required bool front}) {
    return FlipAnimationCard(
      animation: front ? _firstRotation : _secondRotation,
      direction: widget.direction,
      child: front ? widget.front : widget.back,
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }
}

class FlipAnimationCard extends StatelessWidget {
  const FlipAnimationCard(
      {this.child, this.animation, this.direction, Key? key})
      : super(key: key);

  final Widget? child;
  final Animation<double>? animation;
  final CardFlipDirection? direction;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation!,
      builder: (BuildContext context, Widget? child) {
        var transform = Matrix4.identity();
        if (direction == CardFlipDirection.vertical) {
          transform.rotateX(animation!.value);
        } else {
          transform.rotateY(animation!.value);
        }
        return Transform(
          transform: transform,
          alignment: FractionalOffset.center,
          child: child,
        );
      },
      child: child,
    );
  }
}

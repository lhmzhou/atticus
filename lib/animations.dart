import 'package:flutter/material.dart';

class AnimationSwitcher extends StatelessWidget {
  const AnimationSwitcher({
    Key key,
    @required this.child1,
    @required this.child2,
    @required this.animation,
  })  : assert(child1 != null),
        assert(child2 != null),
        assert(animation != null),
        super(key: key);

  final Widget child1;
  final Widget child2;
  final Animation animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) => Stack(
        children: [
          IgnorePointer(
            ignoring: animation.status == AnimationStatus.forward ||
                animation.status == AnimationStatus.completed,
            child: FadeTransition(
              opacity: Tween(begin: 1.0, end: 0.0).animate(animation),
              child: child1,
            ),
          ),
          IgnorePointer(
            ignoring: animation.status == AnimationStatus.reverse ||
                animation.status == AnimationStatus.dismissed,
            child: FadeTransition(
              opacity: animation,
              child: child2,
            ),
          ),
        ],
      ),
    );
  }
}

/// a widget that shows a widget and when it changes, based on given conditions,
/// it will perform top-to-down stack/fade animation (usually, when, e.g. new number is greater than the prev),
/// or same down-to-bot animation
class CountSwitcher extends StatelessWidget {
  const CountSwitcher({
    Key key,
    this.childKey,
    this.child,
    this.valueIncreased = true,
  }) : super(key: key);

  /// a key that will be applied to the child widget, can be used to lock the switch animation.
  final Key childKey;
  final Widget child;

  /// `true` will play top-to-down animation, `false` vice-versa
  final bool valueIncreased;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 20.0),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final baseAnimation = CurvedAnimation(
            curve: Curves.easeOut,
            parent: animation,
          );
          final baseReversedAnimation = CurvedAnimation(
            curve: Curves.easeIn,
            parent: animation,
          );

          final inForwardAnimation = Tween<Offset>(
            begin: const Offset(0.0, -0.7),
            end: const Offset(0.0, 0.0),
          ).animate(baseAnimation);

          final inBackAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.7),
            end: const Offset(0.0, 0.0),
          ).animate(baseAnimation);

          final outForwardAnimation = Tween<Offset>(
            begin: const Offset(0.0, 0.7),
            end: const Offset(0.0, 0.0),
          ).animate(baseReversedAnimation);

          final outBackAnimation = Tween<Offset>(
            begin: const Offset(0.0, -0.7),
            end: const Offset(0.0, 0.0),
          ).animate(baseReversedAnimation);

          //* For entering widget
          if (child.key == childKey) {
            if (valueIncreased)
              return SlideTransition(
                position: inForwardAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            else
              return SlideTransition(
                position: inBackAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
          }
          //* for exiting widget
          else {
            if (valueIncreased) {
              return SlideTransition(
                position: outForwardAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            } else
              return SlideTransition(
                position: outBackAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
          }
        },
        child: Container(
          key: childKey,
          child: child,
        ),
      ),
    );
  }
}

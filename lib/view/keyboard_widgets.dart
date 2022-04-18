import 'dart:async';

import 'package:flutter/widgets.dart';
import '../event/keyboard_event_listener.dart';

// KeyboardInvisibleWidget

class KeyboardInvisibleWidget extends StatefulWidget {
  Widget child;

  bool isReverse = false;

  KeyboardInvisibleWidget({Key? key, required this.child, this.isReverse = false}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KeyboardInvisibleWidgetState();
}

class _KeyboardInvisibleWidgetState extends State<KeyboardInvisibleWidget> {
  bool _isKeyboardVisible = false;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    _isKeyboardVisible = KeyboardEventListener.isVisible;
    keyboardSubscription = KeyboardEventListener.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: widget.isReverse ? !_isKeyboardVisible : _isKeyboardVisible,
      child: widget.child,
    );
  }
}

// KeyboardRebuildWidget

class KeyboardRebuildWidget extends StatefulWidget {
  Function(BuildContext context, bool isKeyboardVisible) builder;

  KeyboardRebuildWidget({Key? key, required this.builder}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _KeyboardRebuildWidgetState();
}

class _KeyboardRebuildWidgetState extends State<KeyboardRebuildWidget> {
  bool _isKeyboardVisible = false;
  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();
    _isKeyboardVisible = KeyboardEventListener.isVisible;
    keyboardSubscription = KeyboardEventListener.listen((bool visible) {
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _isKeyboardVisible);
  }
}

// KeyboardVisibilityBuilder

/// A convenience builder that exposes if the native keyboard is visible.
class KeyboardVisibilityBuilder extends StatelessWidget {
  const KeyboardVisibilityBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(BuildContext context, bool isKeyboardVisible) builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: KeyboardEventListener.stream,
      initialData: KeyboardEventListener.isVisible,
      builder: (context, snapshot) {
        if (snapshot.data is bool) {
          return builder(context, snapshot.data!);
        } else {
          return builder(context, false);
        }
      },
    );
  }
}

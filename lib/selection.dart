import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'main.dart';

typedef StatusListener(SelectionStatus status);
enum SelectionStatus {
  inSelection,
  selecting,
  unselecting,
  notInSelection,
}

/// status listeners will notify about in selection state change
/// listeners will notify about add/remove selection events
class SelectionController<T>
    with
        AnimationLocalListenersMixin,
        AnimationEagerListenerMixin,
        SelectionStatusListenersMixin {
  SelectionController({
    @required this.selectionSet,
    @required this.animationController,
    @required this.switcher,
  }) {
    animationController?.addStatusListener((status) {
      SelectionStatus localStatus;

      switch (status) {
        case AnimationStatus.forward:
          _wasEverSelected = true;
          localStatus = SelectionStatus.selecting;
          break;
        case AnimationStatus.completed:
          localStatus = SelectionStatus.inSelection;
          break;
        case AnimationStatus.reverse:
          localStatus = SelectionStatus.unselecting;
          break;
        case AnimationStatus.dismissed:
          selectionSet.clear();
          localStatus = SelectionStatus.notInSelection;
          break;
      }

      _status = localStatus;
      super.notifyStatusListeners(localStatus);
    });
  }

  final AnimationController animationController;
  final IntSwitcher switcher;
  final Set<T> selectionSet;
  SelectionStatus _status = SelectionStatus.notInSelection;
  bool _wasEverSelected = false;
  int _prevSetLength = 0;

  /// current selection status
  SelectionStatus get status => _status;

  /// returns true if controller was never in the [inSelection] state
  bool get wasEverSelected => _wasEverSelected;

  /// whether controller is in [SelectionStatus.inSelection] or [SelectionStatus.selecting]
  bool get inSelection =>
      _status == SelectionStatus.inSelection ||
      _status == SelectionStatus.selecting;

  /// whether controller is in [SelectionStatus.notInSelection] or [SelectionStatus.unselecting]
  bool get notInSelection =>
      _status == SelectionStatus.notInSelection ||
      _status == SelectionStatus.unselecting;

  /// returns true when current selection set length is greater or equal than the previous.
  /// convenient for tab bar count animation updates, for example.
  bool get lengthIncreased => selectionSet.length >= _prevSetLength;

  /// returns true when current selection set length is less than the previous.
  /// convenient for tab bar count animation updates, for example.
  bool get lengthReduced => selectionSet.length < _prevSetLength;

  void _handleSetChange() {
    _prevSetLength = selectionSet.length;
  }

  /// adds an item to selection set and also notifies click listeners, in case if selection status mustn't change
  void selectItem(T item) {
    if (notInSelection) {
      selectionSet.clear();
    }
    _handleSetChange();
    selectionSet.add(item);

    if (notInSelection && selectionSet.length > 0) {
      animationController.forward();
    } else if (selectionSet.length > 1) {
      notifyListeners();
    }
  }

  /// removes an item to selection set and also notifies click listeners, in case if selection status mustn't change
  void unselectItem(T item) {
    _handleSetChange();
    notifyListeners();
    selectionSet.remove(item);

    if (inSelection && selectionSet.length == 0) {
      animationController.reverse();
    } else {
      notifyListeners();
    }
  }

  /// clears the set and performs the unselect animation
  void close() {
    _handleSetChange();
    switcher.change();
    animationController.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}


/// SelectionStatusListenersMixin is a mixin that implements the addStatusListener/removeStatusListener protocol
/// and notifies all the registered listeners when notifyStatusListeners is called.
mixin SelectionStatusListenersMixin {
  final ObserverList<StatusListener> _statusListeners =
      ObserverList<StatusListener>();

  /// called immediately before a status listener is added via [addStatusListener].
  /// at the time this method is called the registered listener is not yet
  /// notified by [notifyStatusListeners].
  void didRegisterListener();

  /// called immediately after a status listener is removed via [removeStatusListener].
  /// at the time this method is called the removed listener is no longer
  /// notified by [notifyStatusListeners].
  void didUnregisterListener();

  /// calls listener every time the status of the selection changes.
  /// listeners can be removed with [removeStatusListener].
  void addStatusListener(StatusListener listener) {
    didRegisterListener();
    _statusListeners.add(listener);
  }

  /// stops calling the listener every time the status of the selection changes.
  /// listeners can be added with [addStatusListener].
  void removeStatusListener(StatusListener listener) {
    final bool removed = _statusListeners.remove(listener);
    if (removed) {
      didUnregisterListener();
    }
  }

  /// calls all the status listeners.
  /// if listeners are added or removed during this function, the modifications
  /// will not change which listeners are called during this iteration.
  void notifyStatusListeners(SelectionStatus status) {
    final List<StatusListener> localListeners =
        List<StatusListener>.from(_statusListeners);
    for (final StatusListener listener in localListeners) {
      try {
        if (_statusListeners.contains(listener)) listener(status);
      } catch (exception) {
        rethrow;
      }
    }
  }
}
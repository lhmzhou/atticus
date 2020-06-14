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

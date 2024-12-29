import 'dart:async';
import 'package:flutter/widgets.dart';

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel(); // Cancel the previous timer if it's still active
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

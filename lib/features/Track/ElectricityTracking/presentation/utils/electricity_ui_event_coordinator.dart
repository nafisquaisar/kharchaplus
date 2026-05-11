import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';

class ElectricityUiEventCoordinator {
  final Queue<Future<void> Function()> _queue = Queue();
  bool _isRunning = false;

  void enqueue(String label, Future<void> Function() task) {
    debugPrint('[FLUSHBAR QUEUED] $label');
    _queue.add(task);
    _runNext();
  }

  Future<void> _runNext() async {
    if (_isRunning || _queue.isEmpty) {
      return;
    }

    _isRunning = true;
    final task = _queue.removeFirst();
    try {
      await task();
    } catch (e) {
      debugPrint('[UI EVENT ERROR] $e');
    } finally {
      _isRunning = false;
      if (_queue.isNotEmpty) {
        await _runNext();
      }
    }
  }
}


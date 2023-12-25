import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'tracker_page_mixin.dart';
import 'page_tracker_aware.dart';

// 废弃
class TrackerPageWidget extends StatefulWidget {
  final Widget child;

  const TrackerPageWidget({super.key, required this.child});

  @override
  State<TrackerPageWidget> createState() => _TrackerPageWidgetState();
}

class _TrackerPageWidgetState extends State<TrackerPageWidget> with PageTrackerAware, TrackerPageMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didPageView() {
    super.didPageView();

    if (kDebugMode) {
      print("didPageView");
    }
  }

  @override
  void didPageExit() {
    super.didPageExit();

    if (kDebugMode) {
      print("didPageExit");
    }
  }
}

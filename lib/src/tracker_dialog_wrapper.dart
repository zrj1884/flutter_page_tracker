import 'package:flutter/material.dart';
import 'tracker_page_mixin.dart';
import 'page_tracker_aware.dart';

class TrackerDialogWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? didPageView;
  final VoidCallback? didPageExit;

  const TrackerDialogWrapper({
    super.key,
    required this.child,
    this.didPageView,
    this.didPageExit,
  });

  @override
  State<TrackerDialogWrapper> createState() => _TrackerDialogWrapperState();
}

class _TrackerDialogWrapperState extends State<TrackerDialogWrapper> with PageTrackerAware, TrackerPageMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didPageView() {
    super.didPageView();

    widget.didPageView?.call();
  }

  @override
  void didPageExit() {
    super.didPageExit();

    widget.didPageExit?.call();
  }
}

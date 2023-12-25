import 'package:flutter/widgets.dart';
import 'tracker_route_observer.dart';

class TrackerRouteObserverProvider extends InheritedWidget {
  final TrackerStackObserver<ModalRoute> trackerStackObserver = TrackerStackObserver<ModalRoute>();

  TrackerRouteObserverProvider({
    super.key,
    required super.child,
  });

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  static TrackerStackObserver<ModalRoute>? of(BuildContext context) {
    try {
      return (context.dependOnInheritedWidgetOfExactType<TrackerRouteObserverProvider>()
              as TrackerRouteObserverProvider)
          .trackerStackObserver;
    } catch (err) {
      return null;
    }
  }
}

import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'page_tracker_aware.dart';
import 'tracker_route_observer.dart';
import 'page_view_listener_mixin.dart';
import 'tracker_route_observer_provider.dart';

mixin TrackerPageMixin<T extends StatefulWidget> on State<T>, PageTrackerAware {
  TrackerStackObserver<ModalRoute>? _routeObserver;
  PageViewListenerWrapperState? _pageViewListenerWrapperState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_pageViewListenerWrapperState != null) {
      return;
    }

    // 订阅PageView组件中的事件
    _pageViewListenerWrapperState = PageViewListenerMixin.of(context);
    if (_pageViewListenerWrapperState != null) {
      _pageViewListenerWrapperState!.subscribe(this);
      return;
    }

    // 订阅本页面的事件
    if (_routeObserver != null) {
      return;
    }
    _routeObserver = TrackerRouteObserverProvider.of(context);
    if (_routeObserver != null) {
      _routeObserver!.subscribe(this, ModalRoute.of(context)!);
    }
  }

  @override
  void dispose() {
    try {
      _routeObserver?.unsubscribe(this);
      _pageViewListenerWrapperState?.unsubscribe(this);
    } catch (err) {
      rethrow;
    } finally {
      super.dispose();
    }
  }
}

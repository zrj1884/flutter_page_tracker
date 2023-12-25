import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'page_tracker_aware.dart';
import 'page_view_wrapper.dart';
import 'page_load_mixin.dart';

// 处理pageview组件的事件传法
mixin PageViewListenerMixin<T extends StatefulWidget> on State<T>, PageTrackerAware {
  StreamSubscription<PageTrackerEvent>? sb;
  bool isPageView = false;
  // 向列表中的列表转发页面事件
  late Set<PageTrackerAware> subscribers;

  @override
  void initState() {
    super.initState();

    subscribers = <PageTrackerAware>{};
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (sb == null && pageViewIndex != null) {
      Stream<PageTrackerEvent>? stream = PageViewWrapper.of(context, pageViewIndex!);
      // 如果外围没有包裹PageViewWrapper，那么stream为null
      if (stream != null) {
        sb = stream.listen(_onPageTrackerEvent);
        // 应该在首次注册回调事件的时候触发首次页面曝光
        // 这样即使PageView组件随着焦点离开被销毁，也能发页面曝光事件
        _onPageTrackerEvent(PageTrackerEvent.PageView);
      }
    }
  }

  void _onPageTrackerEvent(PageTrackerEvent event) {
    if (event == PageTrackerEvent.PageView) {
      if (!isPageView) {
        didPageView();
        isPageView = true;
      }
    } else {
      if (isPageView) {
        didPageExit();
        isPageView = false;
      }
    }
  }

  int? get pageViewIndex => null;

  @override
  void didPageView() {
    try {
      super.didPageView();
      for (var subscriber in subscribers) {
        subscriber.didPageView();
      }
    } catch (err) {
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  @override
  void didPageExit() {
    try {
      super.didPageExit();
      for (var subscriber in subscribers) {
        subscriber.didPageExit();
      }
    } catch (err) {
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  // 子列表页面订阅页面事件
  void subscribe(PageTrackerAware pageTrackerAware) {
    subscribers.add(pageTrackerAware);
  }

  void unsubscribe(PageTrackerAware pageTrackerAware) {
    subscribers.remove(pageTrackerAware);
  }

  @override
  void dispose() {
    try {
      if (isPageView) didPageExit();
      sb?.cancel();
    } catch (err) {
      rethrow;
    } finally {
      super.dispose();
    }
  }

  static PageViewListenerWrapperState? of(BuildContext context) {
    return context.findAncestorStateOfType<PageViewListenerWrapperState>();
  }
}

typedef OnPageLoadedCallback = void Function(Duration, Duration, Duration, Duration);

// 列表项中还可以再次嵌套列表，所以[PageViewListenerWrapper]需要把
class PageViewListenerWrapper extends StatefulWidget {
  final int index;
  final bool hasRequest;
  final Widget child;
  final VoidCallback? onPageView;
  final VoidCallback? onPageExit;
  final OnPageLoadedCallback? onPageLoaded;

  const PageViewListenerWrapper(
    this.index, {
    super.key,
    this.hasRequest = false,
    required this.child,
    this.onPageView,
    this.onPageExit,
    this.onPageLoaded,
  });

  @override
  PageViewListenerWrapperState createState() {
    return PageViewListenerWrapperState();
  }
}

class PageViewListenerWrapperState extends State<PageViewListenerWrapper>
    with PageTrackerAware, PageViewListenerMixin, PageLoadMixin {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  int get pageViewIndex => widget.index;

  @override
  void didPageView() {
    try {
      super.didPageView();
      widget.onPageView?.call();
    } catch (err) {
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  @override
  void didPageExit() {
    try {
      super.didPageExit();
      widget.onPageExit?.call();
    } catch (err) {
      if (kDebugMode) {
        rethrow;
      }
    }
  }

  @override
  void didPageLoaded(Duration totalTime, Duration buildTime, Duration requestTime, Duration renderTime) {
    try {
      widget.onPageLoaded?.call(totalTime, buildTime, requestTime, renderTime);
    } catch (err) {
      if (kDebugMode) {
        rethrow;
      }
    }
  }
}

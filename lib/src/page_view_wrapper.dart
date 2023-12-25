// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:async';

import 'tracker_page_mixin.dart';
import 'page_tracker_aware.dart';

enum PageTrackerEvent { PageView, PageExit }

// 包裹在PageView TabView组件之外，用于监听Tab切换事件
class PageViewWrapper extends StatefulWidget {
  final int pageAmount;
  final int initialPage;
  final Widget child;
  final ChangeDelegate changeDelegate;

  const PageViewWrapper({
    super.key,
    this.pageAmount = 0,
    this.initialPage = 0,
    required this.child,
    required this.changeDelegate,
  });

  @override
  State<PageViewWrapper> createState() => _PageViewWrapperState();

  // 用于子页面事件监听
  static Stream<PageTrackerEvent>? of(BuildContext context, int index) {
    try {
      assert(index >= 0);
      List<Stream<PageTrackerEvent>> broadCaseStreams =
          ((context.findAncestorStateOfType<_PageViewWrapperState>()))!.broadCaseStreams;
      assert(index < broadCaseStreams.length);

      return broadCaseStreams[index];
    } catch (err) {
      return null;
    }
  }
}

class _PageViewWrapperState extends State<PageViewWrapper> with PageTrackerAware, TrackerPageMixin {
  List<StreamController<PageTrackerEvent>> controllers = [];
  List<Stream<PageTrackerEvent>> broadCaseStreams = [];
  // 上一次打开的Page
  int currPageIndex = 0;
  // 监听子页面控制器
  StreamSubscription<int>? pageChangeSB;

  void _createController(int index) {
    StreamController<PageTrackerEvent> streamController = StreamController<PageTrackerEvent>.broadcast(
        sync: true,
        onCancel: () {
          _createController(index);
        });

    if (index >= controllers.length) {
      controllers.add(streamController);
      broadCaseStreams.add(streamController.stream);
    } else {
      controllers[index] = streamController;
      broadCaseStreams[index] = streamController.stream;
    }    
  }

  @override
  void initState() {
    super.initState();

    currPageIndex = widget.initialPage;

    // 创建streams
    for (int i = 0; i < widget.pageAmount; i++) {
      _createController(i);
    }

    // 发送后续Page事件
    widget.changeDelegate.listen();
    pageChangeSB = widget.changeDelegate.stream.listen(_onPageChange);
  }

  void _onPageChange(int index) {
    if (currPageIndex == index) {
      return;
    }

    // 发送PageExit
    _send(currPageIndex, PageTrackerEvent.PageExit);

    currPageIndex = index;

    // 发送PageView
    _send(currPageIndex, PageTrackerEvent.PageView);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  // PageView/TabView嵌套时使用，将上层的事件转发到下层
  @override
  void didPageView() {
    super.didPageView();
    _send(currPageIndex, PageTrackerEvent.PageView);
  }

  // PageView/TabView嵌套时使用，将上层的事件转发到下层
  @override
  void didPageExit() {
    super.didPageExit();
    // 发送tab中的page离开
    _send(currPageIndex, PageTrackerEvent.PageExit);
  }

  @override
  void dispose() {
    try {
      for(final streamController in controllers) {
        streamController.close();
      }
      pageChangeSB?.cancel();
      widget.changeDelegate.dispose();
    } catch (err) {
      rethrow;
    } finally {
      super.dispose();
    }
  }

  void _send(int index, PageTrackerEvent event) {
    if (currPageIndex < controllers.length && index >= 0) {
      controllers[index].add(event);
    }
  }
}

// Tab切换事件接口
abstract class ChangeDelegate {
  late StreamController<int> streamController;
  late Stream<int> stream;

  ChangeDelegate() {
    streamController = StreamController<int>.broadcast(sync: true);
    stream = streamController.stream;
  }

  void sendPageChange(int index) {
    streamController.add(index);
  }

  @protected
  void listen();

  @protected
  void onChange();

  @protected
  void dispose() {
    streamController.close();
  }
}

class PageViewChangeDelegate extends ChangeDelegate {
  PageController pageController;

  PageViewChangeDelegate(this.pageController) : super();

  @override
  void listen() {
    pageController.addListener(onChange);
  }

  @override
  void onChange() {
    if (pageController.page == null || 0 != pageController.page! % 1.0) {
      return;
    }

    sendPageChange(pageController.page!.toInt());
  }

  @override
  void dispose() {
    try {
      pageController.removeListener(onChange);
    } catch (err) {
      rethrow;
    } finally {
      super.dispose();
    }
  }
}

class TabViewChangeDelegate extends ChangeDelegate {
  TabController tabController;
  int lastIndex = 0;

  TabViewChangeDelegate(this.tabController) : super();

  @override
  void listen() {
    tabController.addListener(onChange);
  }

  @override
  void onChange() {
    if (tabController.index == lastIndex) {
      return;
    } else {
      lastIndex = tabController.index;
      sendPageChange(tabController.index);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}

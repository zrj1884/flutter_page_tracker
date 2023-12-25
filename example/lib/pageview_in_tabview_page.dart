import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_tracker/flutter_page_tracker.dart';

class PageviewInTabviewPage extends StatefulWidget {
  const PageviewInTabviewPage({super.key, required this.title});

  final String title;

  @override
  State<PageviewInTabviewPage> createState() => _PageviewInTabviewPageState();
}

class _PageviewInTabviewPageState extends State<PageviewInTabviewPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<PageviewInTabviewPage> {
  @override
  bool get wantKeepAlive => true;

  late TabController tabController;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    pageController = PageController();
  }

  Widget _buildTag(BuildContext _, int index, int color) {
    return Builder(
      builder: (_) {
        return PageViewListenerWrapper(
          index,
          onPageView: () {
            if (kDebugMode) {
              print("TabView: PageView $index");
            }
          },
          onPageExit: () {
            if (kDebugMode) {
              print("TabView: PageExit $index");
            }
          },
          child: Container(
            color: Colors.blue[color],
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Tab $index: normal tab",
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 45,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed("detail");
                    },
                    child: Container(
                      color: Colors.amber,
                      height: 50,
                      child: const Center(
                        child: Text("Go to another PageRoute"),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPage(int index, int color) {
    return PageViewListenerWrapper(
      index,
      onPageView: () {
        if (kDebugMode) {
          print("pageview $index");
        }
      },
      onPageExit: () {
        if (kDebugMode) {
          print("pageexit $index");
        }
      },
      child: SafeArea(
        child: Container(
          color: Colors.blue[color],
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Page $index wrapped in Tab1",
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                    ),
                    Container(
                      height: 50,
                    ),
                    const Text("For PageView and TabView, PageView and PageExit will be trigged when you "
                        "switch between views."),
                    Container(
                      height: 15,
                    ),
                    Text("You can see 'PageView $index' and 'PageExit $index' in the console."),
                    Container(
                      height: 15,
                    ),
                    const Text("PageExit event will also be trigged when you push a new PageRoute on current stack. "
                        "Try it by clicking the buttom show below. "),
                    Container(
                      height: 15,
                    ),
                    const Text("When you pop a PageRoute, the previous "
                        "focused page will receive a PageView event. "),
                    Container(
                      height: 50,
                    ),
                    const Text("Try slide", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 45,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed("detail");
                  },
                  child: Container(
                    color: Colors.amber,
                    height: 50,
                    child: const Center(
                      child: Text("Go to another PageRoute"),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              PageViewWrapper(
                pageAmount: 3,
                initialPage: 0,
                changeDelegate: TabViewChangeDelegate(tabController),
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: <Widget>[
                    Builder(
                      builder: (BuildContext context) {
                        return PageViewListenerWrapper(0, onPageView: () {
                          // print("tabbar pageview 0");
                        }, onPageExit: () {
                          // print("tabbar pageexit 0");
                        },
                            child: PageViewWrapper(
                              changeDelegate: PageViewChangeDelegate(pageController),
                              pageAmount: 3,
                              initialPage: pageController.initialPage,
                              child: PageView(
                                controller: pageController,
                                children: <Widget>[_buildPage(0, 100), _buildPage(1, 300), _buildPage(2, 500)],
                              ),
                            ));
                      },
                    ),
                    _buildTag(context, 1, 600),
                    _buildTag(context, 2, 900),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: TabBar(
                  controller: tabController,
                  tabs: const <Widget>[
                    Tab(
                      text: "Tab1",
                    ),
                    Tab(
                      text: "Tab2",
                    ),
                    Tab(
                      text: "Tab3",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

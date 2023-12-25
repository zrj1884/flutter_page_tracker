import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_tracker/flutter_page_tracker.dart';

class PageViewMixinPage extends StatefulWidget {
  const PageViewMixinPage({super.key, required this.title});


  final String title;

  @override
  State<PageViewMixinPage> createState() => _PageViewMixinPageState();
}

class _PageViewMixinPageState extends State<PageViewMixinPage> with AutomaticKeepAliveClientMixin<PageViewMixinPage> {

  @override
  bool get wantKeepAlive => true;

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PageViewWrapper(
        changeDelegate: PageViewChangeDelegate(pageController),
        pageAmount: 3,
        initialPage: pageController.initialPage,
        child: PageView(
          controller: pageController,
          children: const <Widget>[
            Page(index: 0, color: 300,),
            Page(index: 1, color: 600,),
            Page(index: 2, color: 900,),
          ],
        ),
      )
    );
  }
}

class Page extends StatefulWidget {
  final int index;
  final int color;

  const Page({super.key, required this.index, required this.color});

  @override
  PageState createState() {
    return PageState();
  }
}

class PageState extends State<Page> with PageTrackerAware, PageViewListenerMixin, PageLoadMixin {

  @override
  int get pageViewIndex => widget.index;

  @override
  void didPageView() {
    super.didPageView();
    if (kDebugMode) {
      print("PageView mixin ${widget.index}");
    }
  }

  @override
  void didPageExit() {
    super.didPageExit();
    if (kDebugMode) {
      print("PageExit mixin ${widget.index}");
    }
  }

  @override
  void didPageLoaded(totalTime, buildTime, requestTime, renderTime) {
    // DoSomething
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.blue[widget.color],
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Page ${widget.index}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                  Container(height: 50,),
                  const Text("For PageView and TabView, PageView and PageExit will be trigged when you "
                      "switch between views."),
                  Container(height: 15,),
                  Text("You can see 'PageView $widget.index' and 'PageExit $widget.index' in the console."),
                  Container(height: 15,),
                  const Text("PageExit event will also be trigged when you push a new PageRoute on current stack. "
                      "Try it by clicking the buttom show below. "),
                  Container(height: 15,),
                  const Text("When you pop a PageRoute, the previous "
                      "focused page will receive a PageView event. "),
                  Container(height: 50,),
                  const Text("Try slide", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
                ],
              ),
            ),
            GestureDetector(
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
            )
          ],
        ),
      ),
    );
  }
}

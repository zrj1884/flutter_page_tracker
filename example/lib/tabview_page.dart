import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_tracker/flutter_page_tracker.dart';

class TabViewPage extends StatefulWidget {
  const TabViewPage({super.key, required this.title});


  final String title;

  @override
  State<TabViewPage> createState() => _TabViewPageState();
}

class _TabViewPageState extends State<TabViewPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<TabViewPage> {

  @override
  bool get wantKeepAlive => true;

  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
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
                      Text("Tab $index", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),),
                      Container(height: 50,),
                      const Text("For PageView and TabView, PageView and PageExit will be trigged when you "
                          "switch between views."),
                      Container(height: 15,),
                      Text("You can see 'PageView $index' and 'PageExit $index' in the console."),
                      Container(height: 15,),
                      const Text("PageExit event will also be trigged when you push a new PageRoute on current stack. "
                          "Try it by clicking the buttom show below."),
                      Container(height: 15,),
                      const Text("When you pop a PageRoute, the previous "
                          "focused tab will receive a PageView event. "),
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SafeArea(
          child: Container(
            color: Colors.blue,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                PageViewWrapper(
                  pageAmount: 3,
                  initialPage: 0,
                  changeDelegate: TabViewChangeDelegate(tabController),
                  child: TabBarView(
                    controller: tabController,
                    children: <Widget>[
                      _buildTag(context, 0, 300),
                      _buildTag(context, 1, 600),
                      _buildTag(context, 2, 900),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.amber[900],
                    child: TabBar(
                      controller: tabController,
                      tabs: const <Widget>[
                        Tab(text: "Tab1",),
                        Tab(text: "Tab2",),
                        Tab(text: "Tab3",),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_tracker/flutter_page_tracker.dart';
import 'package:example/popup_page.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with PageTrackerAware, TrackerPageMixin, PageLoadMixin {

  Widget _button(String text, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.amber[500 + 100 * Random().nextInt(4)],
          height: 50,
          child: Center(
            child: Text(text),
          ),
        )
    );
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                color: Colors.blue,
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text("flutter_page_tracker is a flutter plugin which "
                        "help tracking route events of PageRoute/PopupRoute/PageView/TabView."),
                    Container(height: 50,),
                    const Text("1. Route events include PageView and PageExit."),
                    Container(height: 15,),
                    const Text("2. For PageRoute, when the current route is pushed to the top of the stack, "
                        "a PageView event will be trigged on the current, and a PageExit event will "
                        "be trigged on previous route, and vice versa for pop route."),
                    Container(height: 15,),
                    const Text("3. For PopupRoute, only PageView will be trigged when dialog "
                        "is pushed, and vice versa for pop route."),
                    Container(height: 15,),
                    const Text("4. For PageView and TabView, PageView and PageExit will be trigged when you "
                        "switch between views.")
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  _button(
                    'PageRoute demo',
                    () {
                      Navigator.of(context).pushNamed("detail");
                    }
                  ),
                  _button(
                    'PopupRoute demo',
                          () {
                        showDialog(
                            context: context,
                            builder: (_) {
                              return const PopupPage();
                            }
                        );
                      }
                  ),
                  _button(
                      'PageView Mixin demo',
                          () {
                        Navigator.of(context).pushNamed("pageview_mixin");
                      }
                  ),
                  _button(
                    'PageView Wrapper demo',
                    () {
                      Navigator.of(context).pushNamed("pageview");
                    }
                  ),
                  _button(
                      'TapView demo',
                          () {
                            Navigator.of(context).pushNamed("tabview");
                      }
                  ),
                  _button(
                      'Pageview Wraped in TabView demo',
                          () {
                        Navigator.of(context).pushNamed("pageviewInTabView");
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void didPageView() {
    super.didPageView();

    if (kDebugMode) {
      print("Tracker PageView: home");
    }
  }

  @override
  void didPageLoaded(Duration totalTime, Duration buildTime, Duration requestTime, Duration renderTime) {
    // DoSomething
  }

  @override
  void didPageExit() {
    super.didPageExit();

    if (kDebugMode) {
      print("Tracker PageExit: home");
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_tracker/flutter_page_tracker.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> with PageTrackerAware, TrackerPageMixin, PageLoadMixin {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("PageRoute Demo"),
      ),
      body: Container(
        color: Colors.blue,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const Text(
              "When a PageRoute is added to navigation stack, a PageExit event "
                  "will be trigged on previous route and you can override didPageExit method"
                  "by using TrackerPageMixin. ",
            ),
            Container(
              height: 10,
            ),
            const Text(
              "After PageExit event, a PageView event will be trigged on current route.",
            ),
            Container(
              height: 10,
            ),
            const Text("Vice versa for the pop of PageRoute."),
            Container(
              height: 50,
            ),
            const Text("You can see 'Tracker PageView: detail' and 'Tracker PageExit: detail' in the "
                "console panel.")
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void didPageView() {
    super.didPageView();

    if (kDebugMode) {
      print("Tracker PageView: detail");
    }
  }

  @override
  void didPageExit() {
    super.didPageExit();

    if (kDebugMode) {
      print("Tracker PageExit: detail");
    }
  }

  @override
  void didPageLoaded(Duration totalTime, Duration buildTime, Duration requestTime, Duration renderTime) {
    // DoSomething
  }
}

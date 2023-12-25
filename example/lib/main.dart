import 'package:flutter/material.dart';
import 'package:flutter_page_tracker/flutter_page_tracker.dart';

// 页面
import 'home_page.dart';
import 'detail_page.dart';
import 'pageview_wrapper_page.dart';
import 'tabview_page.dart';
import 'pageview_in_tabview_page.dart';
import 'pageview_mixin_page.dart';

void main() => runApp(TrackerRouteObserverProvider(
      child: const PageLoadProvider(env: "dev", child: MyApp()),
    ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: const TextTheme(
            labelLarge: TextStyle(fontSize: 20),
            displayLarge: TextStyle(fontSize: 20),
            displayMedium: TextStyle(fontSize: 18),
            displaySmall: TextStyle(fontSize: 16),
            headlineLarge: TextStyle(fontSize: 20),
            headlineMedium: TextStyle(fontSize: 18),
            titleLarge: TextStyle(fontSize: 20),
            bodyLarge: TextStyle(fontSize: 20, color: Colors.white),
          )),
      navigatorObservers: [TrackerRouteObserverProvider.of(context)!],
      home: const MyHomePage(title: 'Flutter_Page_tracker Demo'),
      routes: {
        "home": (_) => const MyHomePage(title: 'Flutter_Page_tracker Demo'),
        "detail": (_) => const DetailPage(),
        "pageview_mixin": (_) => const PageViewMixinPage(title: 'PageView Mixin Demo'),
        "pageview": (_) => const PageViewWrapperPage(title: 'PageView Wrapper Demo'),
        "tabview": (_) => const TabViewPage(title: 'TabView Demo'),
        "pageviewInTabView": (_) => const PageviewInTabviewPage(title: 'Pageview Wraped in TabView demo'),
      },
    );
  }
}

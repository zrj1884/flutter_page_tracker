import 'package:flutter/widgets.dart';

class PageLoadProvider extends InheritedWidget {

  final String env;

  const PageLoadProvider({
    super.key,
    this.env = 'pro',
    required super.child,
  });

  @override
  bool updateShouldNotify(PageLoadProvider oldWidget) {
    return env != oldWidget.env;
  }

  static String of(BuildContext context) {
    try {
      return (context.dependOnInheritedWidgetOfExactType<PageLoadProvider>() as PageLoadProvider).env;
    } catch (err) {
      return "pro";
    }
  }
}
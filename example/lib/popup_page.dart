import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_tracker/flutter_page_tracker.dart';
import 'dart:math';

class PopupPage extends StatelessWidget {

  const PopupPage({
    super.key,
  });

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
    return TrackerDialogWrapper(
      didPageView: () {
        if (kDebugMode) {
          print('dialog didPageView');
        }
      },
      didPageExit: () {
        if (kDebugMode) {
          print('dialog didPageExit');
        }
      },
      child: SimpleDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        children: <Widget>[
          ClipRRect(
            clipBehavior: Clip.antiAlias,
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            child: Container(
              width: 400,
              color: Colors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text("When you show a dialog, only PageView event will be trigged. "),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: const Text("You can see 'dialog didPageView' in the console. "),
                  ),
                  Container(height: 10,),
                  _button("Go to anther PageRoute, will not trigger PageExit on this dialog", () {
                    Navigator.of(context).pushNamed("detail");
                  }),
                  _button("Close dialog, will not trigger PageView on Previous route", () {
                    Navigator.of(context).pop();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
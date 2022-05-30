import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chat_screens/chats.dart';
import '../chat_screens/people.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  var screens = [Chats(), People()];

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CupertinoTabScaffold(
        resizeToAvoidBottomInset: true,
        tabBar: CupertinoTabBar(
          items: [
            BottomNavigationBarItem(
              label: "Chats",
              icon: Icon(CupertinoIcons.chat_bubble_2_fill),
            ),

            BottomNavigationBarItem(
              label: "People",
              icon: Icon(CupertinoIcons.person_alt_circle),
            ),

          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return screens[index];
        },
      ),
    );
  }
}
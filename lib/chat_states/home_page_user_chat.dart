import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../chat_screens/chats.dart';
import '../chat_screens/people_user.dart';
class HomePageChatUser extends StatelessWidget {
  HomePageChatUser({Key? key}) : super(key: key);
  var screens = [const Chats(), PeopleUser()];

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

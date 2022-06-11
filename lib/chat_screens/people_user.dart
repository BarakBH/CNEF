import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import 'chat_detail.dart';

import 'chat_detail.dart';
class PeopleUser extends StatelessWidget {
  PeopleUser({Key? key}) : super(key: key);
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  void callChatDetailScreen(BuildContext context, String name, String uid) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendUid: uid, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where('role', isEqualTo: 'admin')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text("People"),
                ),
                SliverList(

                  delegate: SliverChildListDelegate(

                    snapshot.data!.docs.map(
                          (DocumentSnapshot document) {
                        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                        return CupertinoListTile(
                          leading: data['badge_message']>0?Badge(
                            alignment: Alignment.bottomRight,
                            padding: EdgeInsets.all(6),
                            badgeColor: Colors.redAccent,
                            toAnimate: false,
                            showBadge:true,
                            position: BadgePosition.topEnd(),
                            badgeContent: Text("${data['badge_message']}",textAlign:TextAlign.center,style: TextStyle(
                              fontSize: 14,

                              color: Colors.white ,
                              fontWeight: FontWeight.bold,
                            ),),


                          )
                              :null
                          ,
                         onTap: () {
                          addBadge(data['uid']);
                          callChatDetailScreen(
                              context, data['firstName'], data['uid']);

                        },
                          title: Text("${data['firstName']} ${data['lastname']}"),
                          subtitle: Text("${data['role']}"),
                        );
                      },
                    ).toList(),
                  ),
                )
              ],
            );
          }

          return Container();
        }

        );
  }
  void addBadge(final uid){
   // FirebaseFirestore.instance.collection('users').doc(uid).update({'badge_message':0 });

  }

}

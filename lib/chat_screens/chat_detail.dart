import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/screens_user/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';

import '../model/user_model.dart';

class ChatDetail extends StatefulWidget {
 // static String copy_friend_uid="";
  final friendUid;
  final friendName;

  ChatDetail({Key? key, this.friendUid, this.friendName}) : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState(friendUid, friendName);
}

class _ChatDetailState extends State<ChatDetail> {

  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final friendUid;
  final friendName;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  UserModel friendUser = UserModel();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel currentUser=UserModel();

  var chatDocId;
  var _textController = new TextEditingController();
  _ChatDetailState(this.friendUid, this.friendName);
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      currentUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });
    checkUser();

  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {friendUid: null, currentUserId: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          setState(() {
            chatDocId = querySnapshot.docs.single.id;
          });

          print(chatDocId);
        } else {
          await chats.add({
            'users': {currentUserId: null, friendUid: null},
            'names':{currentUserId:FirebaseAuth.instance.currentUser?.uid,friendUid:friendName}
          }).then((value) => {chatDocId = value});
        }
      },
    )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    if(msg.contains('OK OK') && currentUser.role=='admin'){
      var collection = FirebaseFirestore.instance.collection("users");
      collection
          .doc(friendUid)
          .update({'rdv': true});
    }
    if(msg.contains('rdv bien passé')&& currentUser.role=='admin'){
      var collection = FirebaseFirestore.instance.collection("users");
      collection
          .doc(friendUid)
          .update({'rdv': false});
    }
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'friendName':friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';

    });
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder<QuerySnapshot>(
      stream: chats
          .doc(chatDocId)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }


        if (snapshot.hasData) {
          var data;
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(friendName),
              previousPageTitle: "Back",
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      reverse: true,
                      children: snapshot.data!.docs.map(
                            (DocumentSnapshot document) {
                          data = document.data()!;
                          print(document.toString());
                          print(data['msg']);
                          return Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                            child: ChatBubble(
                              clipper: ChatBubbleClipper6(
                                 type: isSender(data['uid'].toString())
                                    ? BubbleType.sendBubble
                                    : BubbleType.receiverBubble,
                              ),
                              alignment: getAlignment(data['uid'].toString()),
                              margin: EdgeInsets.only(top: 10),
                              backGroundColor: isSender(data['uid'].toString())
                                  ? Colors.lightBlue
                                  : Colors.grey[200],
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                  MediaQuery.of(context).size.width * 0.7,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                    //  mainAxisAlignment: MainAxisAlignment.start,
                                    //  crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Flexible(
                                            child:
                                        Text(data['msg'],
                                            style: TextStyle(
                                              inherit: false,
                                              fontSize: 20,
                                                color: isSender(
                                                    data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.black),
                                            overflow: TextOverflow.visible)
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          child:
                                        Text(
                                          data['createdOn'] == null
                                              ? DateTime.now().toString()
                                              : data['createdOn']
                                              .toDate()
                                              .toString(),
                                          style: TextStyle(
                                            inherit: false,
                                              fontSize: 10,
                                              color: isSender(
                                                  data['uid'].toString())
                                                  ? Colors.white
                                                  : Colors.black),
                                          maxLines: 100,
                                        )
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: CupertinoTextField(
                            controller: _textController,
                          ),
                        ),
                      ),
                      CupertinoButton(
                          child: Icon(Icons.send_sharp),
                          onPressed: () => sendMessage(_textController.text))
                    ],
                  )
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }


}
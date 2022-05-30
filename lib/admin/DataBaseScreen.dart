import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/admin_model.dart';
import '../model/user_model.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'AllRequests.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';
List<DocumentSnapshot> ?documents_2;
List<DocumentSnapshot> ?documents_3;
List<DocumentSnapshot> ?documents_4;

class DataBaseScreen extends StatefulWidget {
  const DataBaseScreen({Key? key}) : super(key: key);

  @override
  _DataBaseScreenState createState() => _DataBaseScreenState();
}
final database1 = FirebaseFirestore.instance;
Future<QuerySnapshot> years = database1.collection('old_student').get();
final database2 = FirebaseFirestore.instance;
Future<QuerySnapshot> years2 = database2.collection('users').where('role',isEqualTo: 'user').get();
final database3 = FirebaseFirestore.instance;
Future<QuerySnapshot> years3 = database3.collection('users').where('role',isEqualTo: 'admin').get();
class _DataBaseScreenState extends State<DataBaseScreen> {
  @override
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      loggedUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });
  }

  Widget build(BuildContext context) {
    final List<String> imgList = [
      "assets/event1_cnef.jpg",
    ];
    return Scaffold(

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                  "${loggedUser.firstname.toString()} ${loggedUser.lastName
                      .toString()}"),
              accountEmail: Text("${loggedUser.email}"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    "assets/user_image.png",


                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey,

              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreenAdmin())),
              },
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: Text("DataBase"),
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DataBaseScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add Post"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddPostScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_phone),
              title: Text("All Requests"),
              onTap: () =>
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllRequestsScreen()))
              },
            ),

            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About us "),
              onTap: () =>
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutUsAdminScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                logout(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("DataBase"),

      ),
        body : Column(
            children:<Widget>[

              Text("Old Student  ",style: TextStyle(
                fontSize: 20,
                inherit: true,

              ),),
              Expanded(
                  child :FutureBuilder<QuerySnapshot>(

                      future: years,
                      builder: (context, snapshot) {
                        documents_2= snapshot.data!.docs;
                        return ListView(
                            children: documents_2
                            !.map((doc) =>
                                Card(
                                  child: ListTile(

                                    title: Text(
                                        '${doc.get('firstName')} ${doc.get(
                                            'lastName')}\n${doc.get(
                                            'domaine')}\n${doc.get(
                                    'email')}'),
                                  ),
                                )).toList()
                        );

                      }



                  )
              ),
              Text("Users",style: TextStyle(
                fontSize: 20,
                inherit: true,

              ),),
              Expanded(
                  child :FutureBuilder<QuerySnapshot>(

                      future: years2,
                      builder: (context, snapshot) {
                        documents_3= snapshot.data!.docs;
                        return ListView(
                            children: documents_3
                            !.map((doc) =>
                                Card(
                                  child: ListTile(
                                    title: Text(
                                        '${doc.get('firstName')} ${doc.get(
                                            'lastname')}\n${doc.get(
                                            'email')}'),
                                  ),
                                )).toList()
                        );

                      }



                  )
              ),
              Text("Admins  ",style: TextStyle(
                fontSize: 20,
                inherit: true,

              ),),
              Expanded(
                  child :FutureBuilder<QuerySnapshot>(
                      future: years3,
                      builder: (context, snapshot) {
                        documents_4= snapshot.data!.docs;
                        return ListView(
                            children: documents_4
                            !.map((doc) =>
                                Card(
                                  child: ListTile(
                                    title: Text(
                                        '${doc.get('firstName')} ${doc.get(
                                            'lastname')}\n${doc.get(
                                            'email')}'),
                                  ),
                                )).toList()
                        );

                      }



                  )
              ),
            ]
        )



    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}


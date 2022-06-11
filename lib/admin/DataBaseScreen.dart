import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../model/admin_model.dart';
import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'AllRequests.dart';
import 'add_event.dart';
import 'add_someone.dart';
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
              leading: Icon(Icons.add),
              title: Text("Add Event"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEvent()))
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add Someone"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddSomeone()))
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
        body :FirestoreSearchScaffold(
         appBarBackgroundColor: Colors.white,
          firestoreCollectionName: 'users',
          searchBy: 'firstName',
          scaffoldBody: Center(),
          dataListFromSnapshot: UserModel().dataListFromSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<UserModel>? dataList = snapshot.data;
              if (dataList!.isEmpty) {
                PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
                return RefreshIndicator(
                  child: PaginateFirestore(
                    itemBuilder: (context, documentSnapshots, index) {
                      final data = documentSnapshots[index].data() as Map?;
                      return ListTile(
                      leading: CircleAvatar(

                        child: data ==null ||data['role']=='admin'  ?
                        Icon(Icons.person):
                        ClipOval(
                      child : Image.network(
                      data['file'].toString(),
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,


                      ),
                      ),
                      ),
                        title: data==null ? Text('Error in data') : Text(data['firstName']+" "+data['lastname'],style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),),
                      subtitle:  data==null ? Text('Error in data') :Text(data['role'],style: TextStyle(
                        color: Colors.red,

                      ),),
                      );
                    } ,
                    // orderBy is compulsary to enable pagination
                    query: FirebaseFirestore.instance.collection('users').orderBy('firstName'),
                    listeners: [
                      refreshChangeListener,
                    ], itemBuilderType: PaginateBuilderType.listView,

                  ),
                  onRefresh: () async {
                    refreshChangeListener.refreshed = true;
                  },
                );
              }
              return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final UserModel data = dataList[index];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    ListTile(
                    leading: CircleAvatar(

                      child: '${data.role}'=='admin'  ?
                      Icon(Icons.person):
                      ClipOval(
                        child : Image.network(
                          '${data.file}'.toString(),
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,


                        ),
                      ),
                    ),
                    title: Text('${data.firstname} ${data.lastName}',style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),),
                    subtitle: Text('${data.role}',style: TextStyle(
                      color: Colors.red,

                    ),),
                    ),
                      ],
                    );
                  });
            }

            if (snapshot.connectionState == ConnectionState.done) {
              if (!snapshot.hasData) {
                return const Center(
                  child: Text('No Results Returned'),
                );
              }
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        )

    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
}


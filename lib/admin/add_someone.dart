import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/add_new_old_student.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';
import 'add_new_family.dart';
import 'home_screen_admin.dart';

class AddSomeone extends StatefulWidget {
  const AddSomeone({Key? key}) : super(key: key);

  @override
  _AddSomeoneState createState() => _AddSomeoneState();
}

class _AddSomeoneState extends State<AddSomeone> {
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                  "${loggedUser.firstname} ${loggedUser.lastName}"),
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
              iconColor: Colors.red,
              textColor: Colors.red,
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
        title: Text("Add Someone "),

      ),

      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.add_event,
        backgroundColor: Colors.indigo,
        children: [
          SpeedDialChild(
              backgroundColor: Colors.lightGreen[600],
              child: Icon(Icons.family_restroom),
              label: 'Ajouter une gentille famille',
              onTap: ()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNewFamily()),)


              }

          ),
          SpeedDialChild(
              backgroundColor: Colors.blueGrey[300],
              child: Icon(Icons.work),
              label: 'Ajouter un ancien élève',
              onTap: ()=>{
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddNewOldStudent()),)


              }
          ),

        ],
      ),

     body: Center(),

    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
}

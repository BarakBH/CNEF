import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/meeting_editing.dart';
import 'package:cnef_app/admin/profile_page_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';
import 'add_someone.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';
List<DocumentSnapshot> ?documents_2;
List<DocumentSnapshot> ?documents_3;
List<DocumentSnapshot> ?documents_4;
var collection = FirebaseFirestore.instance.collection("users");
final database1 = FirebaseFirestore.instance;
Future<QuerySnapshot> years = database1.collection('meeting').get();
final database2 = FirebaseFirestore.instance;
Future<QuerySnapshot> years2 = database2.collection('users').where('role',isEqualTo: 'user').get();
class AllMeetingsView extends StatefulWidget {
  const AllMeetingsView({Key? key}) : super(key: key);

  @override
  _AllMeetingsViewState createState() => _AllMeetingsViewState();
}

class _AllMeetingsViewState extends State<AllMeetingsView> {
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
        accountName: Text("${loggedUser.firstname.toString()} ${loggedUser.lastName.toString()}"),
    accountEmail: Text("${loggedUser.email}"),
    currentAccountPicture: CircleAvatar(
    child : ClipOval(
    child : Image.asset(
    "assets/user_image.png",



    ),
    ),
    ),
    decoration: BoxDecoration(
    color: Colors.blueGrey,

    ),
    ),
    ListTile(
    leading : Icon(Icons.home),
    title : Text("Menu"),

    onTap: ()=> {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreenAdmin())),
    },
    ),
    ListTile(
    leading : Icon(Icons.account_circle_rounded),
    title : Text("Profil"),
    onTap: ()=> {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfilePageAdmin())),
    },
    ),
    ListTile(
    leading : Icon(Icons.web),
    title : Text("Users/Admins"),
    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DataBaseScreen()))
    },
    ),

    ListTile(
    leading : Icon(Icons.add),
    title : Text("Ajouter un post"),
    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddPostScreen()))
    },
    ),
    ListTile(
    leading: Icon(Icons.add),
    title: Text("Ajouter un événement"),
    onTap: () =>
    {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => AddEvent()))
    },
    ),
    ListTile(
    leading: Icon(Icons.add),
    title: Text("Ajouter ancien étudiant/famille"),
    onTap: () =>
    {
    Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const AddSomeone()))
    },
    ),
    ListTile(
            leading : Icon(Icons.calendar_today),
      iconColor: Colors.red,
      textColor: Colors.red,
            title : Text("RDV conseillère/Autorisations"),
            onTap: ()=>{
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AllMeetingsView()))
            },
          ),
    ListTile(
    leading : Icon(Icons.contact_phone),
    title : Text("Toutes les demandes"),
    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AllRequestsScreen()))
    },
    ),

    ListTile(
    leading : Icon(Icons.info_outline),
    title : Text("A propos de nous"),
    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AboutUsAdminScreen()))
    },
    ),
    ListTile(
    leading : Icon(Icons.logout),
    title : Text("Se déconnecter"),
    onTap: (){
    logout(context);
    },
    )
    ],
    ),
    ),
        appBar:AppBar(
          backgroundColor: Colors.red,
          title :Text("RDV conseillère/Autorisations"),

        ),
    floatingActionButton: FloatingActionButton(
        child : Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MeetingEditing()),);
        }
    ),
    body:Column(
        children:<Widget>[

          Text("\nAutorisations de RDV\n",style: TextStyle(
            fontSize: 20,
            fontWeight:FontWeight.bold

          ),),
          Expanded(
              child :FutureBuilder<QuerySnapshot>(
                  future: years2,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                     documents_2 = snapshot.data!.docs;

                      return ListView(

                          children: documents_2
                          !.map((doc) =>
                              Card(
                                child: ListTile(
                                  tileColor: doc.get('rdv')==false? Colors.redAccent : Colors.green[700],

                                  title: Text(
                                    '${doc.get('firstName')} ${doc.get(
                                        'lastname')}',),
                                ),
                              )).toList()
                      )
                      ;
                    }
                    else if (snapshot.hasError) {
                      return Text('Error!');
                    } else {
                      return Container();
                    }

                  }



              )
          ),
          Text("RDV\n",style: TextStyle(
            fontSize: 20,

          ),),
          Expanded(
              child :FutureBuilder<QuerySnapshot>(
                  future: years,
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      documents_3 = snapshot.data!.docs;

                      return ListView(

                          children: documents_3
                          !.map((doc) =>
                              Card(
                                child: ListTile(

                                  title: Text(
                                    '${doc.get('user')} a pris RDV de \n${doc.get('start').toDate().toString()} à \n${doc.get('end').toDate().toString()}',style: TextStyle(
                                    fontSize: 18,
                                  ),),
                                ),
                              )).toList()
                      )
                      ;
                    }
                    else if (snapshot.hasError) {
                      return Text('Error!');
                    } else {
                      return Container();
                    }

                  }



              )
          ),




        ]
    )

    );
  }
   Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
}

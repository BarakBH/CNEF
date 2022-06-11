import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';
import 'add_someone.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';
List<DocumentSnapshot> ?documents_requests;
List<DocumentSnapshot> ?documents_requests2;

class AllRequestsScreen extends StatefulWidget {
  const AllRequestsScreen({Key? key}) : super(key: key);

  @override
  _AllRequestsScreenState createState() => _AllRequestsScreenState();
}
final database1 = FirebaseFirestore.instance;
Future<QuerySnapshot> years = database1.collection('request_users').get();
final database2 = FirebaseFirestore.instance;
Future<QuerySnapshot> years2 = database2.collection('invitation_user').get();
class _AllRequestsScreenState extends State<AllRequestsScreen> {
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
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }

  @override
  Widget build(BuildContext context) {
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
              iconColor: Colors.red,
              textColor: Colors.red,
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
        title: Text("All Requests"),

      ),

      body : Column(
        children:<Widget>[

        Text("Request funds ",style: TextStyle(
        fontSize: 20,
        inherit: true,

      ),),
      Expanded(
          child :FutureBuilder<QuerySnapshot>(

              future: years,
              builder: (context, snapshot) {
                documents_requests= snapshot.data!.docs;
                return ListView(
                    children: documents_requests
                    !.map((doc) =>
                        Card(
                          child: ListTile(
                            title: Text(
                                "Eytan a fait une demande d'un montant de ${doc.get('montant')}\n${doc.get('description')}}"
                                    ),
                            
                          ),
                          
                        )).toList()
                );

              }



          )
      ),
          Text("Requests Chabbat",style: TextStyle(
            fontSize: 20,
            inherit: true,

          ),),
          Expanded(
              child :FutureBuilder<QuerySnapshot>(

                  future: years2,
                  builder: (context, snapshot) {
                    documents_requests2= snapshot.data!.docs;
                    return ListView(
                        children: documents_requests2
                        !.map((doc) =>
                            Card(
                              child: ListTile(
                                title: Text(
                                    "Eytan demande a etre invite Chabbat a ${doc.get('location')}\n${doc.get('location')}"
                                ),

                              ),

                            )).toList()
                    );

                  }



              )
          ),
      ]
      ),
    );
  }

}

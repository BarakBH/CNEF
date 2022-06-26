import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/add_new_old_student.dart';
import 'package:cnef_app/admin/profile_page_admin.dart';
import 'package:cnef_app/model/family_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';
import 'add_new_family.dart';
import 'all_meetings_view.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';

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
              title: Text("Menu"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreenAdmin())),
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
              leading: Icon(Icons.web),
              title: Text("Users/Admins"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DataBaseScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Ajouter un post"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddPostScreen()))
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
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddSomeone()))
              },
            ),
            ListTile(
              leading : Icon(Icons.calendar_today),
              title : Text("RDV conseillère/Autorisations"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AllMeetingsView()))
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_phone),
              title: Text("Toutes les demandes"),

              onTap: () =>
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllRequestsScreen()))
              },
            ),

            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("A propos de nous"),

              onTap: () =>
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutUsAdminScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Se déconnecter"),
              onTap: () {
                logout(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Ajouter ancien étudiant/famille"),

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

        body :
        FirestoreSearchScaffold(
          appBarBackgroundColor: Colors.white,
          firestoreCollectionName: 'family',
          searchBy: 'lastName',
          scaffoldBody: Center(),
          dataListFromSnapshot: FamilyModel().dataListFromSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<FamilyModel>? dataList = snapshot.data;
              if (dataList!.isEmpty) {
                PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
                return RefreshIndicator(
                  child: PaginateFirestore(
                    itemBuilder: (context, documentSnapshots, index) {
                      final data = documentSnapshots[index].data() as Map?;
                      return ListTile(

                        title: data==null ? Text('Error in data') : Text("Famille"+data['lastName'],style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        ),
                        subtitle: data==null?Text('Error in data'): Text( "Location: "+data['location']+"\nNumberphone : "+data['numberPhone']+"\nMax Persons "+data['maxNumberPerson'])
                        ,


                      );
                    } ,
                    // orderBy is compulsary to enable pagination
                    query: FirebaseFirestore.instance.collection('family').orderBy('lastName'),
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
                    final FamilyModel data = dataList[index];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text('Famille ${data.lastName}',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                          subtitle:Text('Location : ${data.location}\nNumberPhone : ${data.numberPhone}\nMaxPersons:${data.maxNumberPerson}',style: TextStyle(fontSize: 15,))


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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/model/old_student_model.dart';
import 'package:cnef_app/screens_user/home_screen_general.dart';
import 'package:cnef_app/screens_user/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:cnef_app/screens_user/FamiliesContact_screen.dart';
import 'package:flutter/services.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'dart:developer';

import '../model/user_model.dart';
import 'AboutUs_screen.dart';
import 'Requestfund_screen.dart';
import 'home_screen.dart';
List<DocumentSnapshot> ?documents_2;
DocumentSnapshot ?petit_document;

class ContactStudent extends StatefulWidget {
  const ContactStudent({Key? key}) : super(key: key);

  @override
  _ContactStudentState createState() => _ContactStudentState();
}
final database1 = FirebaseFirestore.instance;
Future<QuerySnapshot> years = database1.collection('old_student').get();

class _ContactStudentState extends State<ContactStudent> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      loggedInuser = UserModel.fromMap(value.data());
      setState(() {

      });
    });



  }



  @override
  Widget build(BuildContext context) {
    final controller =TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text("${loggedInuser.firstname.toString()} ${loggedInuser.lastName.toString()}"),
                accountEmail: Text("${loggedInuser.email}"),
                currentAccountPicture: CircleAvatar(
                  child : ClipOval(
                    child : Image.network(
                      "${loggedInuser.file.toString()}",
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                ),
              ),
              ListTile(
                leading : Icon(Icons.home),
                title : Text("Home"),
                onTap: ()=> {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen())),
                },
              ),
              ListTile(
                leading : Icon(Icons.family_restroom),
                title : Text("Families Contact"),
                onTap: ()=>{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FamiliesContact()))
                },
              ),

              ListTile(
                leading : Icon(Icons.contact_phone),
                title : Text("Contact Student(s)"),
                iconColor: Colors.red,
                textColor: Colors.red,
                onTap: ()=>{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ContactStudent()))
                },
              ),
              ListTile(
                leading : Icon(Icons.attach_money),
                title : Text("Request funds"),
                onTap: ()=>{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RequestFunds()))
                },
              ),
              ListTile(
                leading : Icon(Icons.info_outline),
                title : Text("About us "),
                onTap: ()=>{
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AboutUs()))
                },
              ),
              ListTile(
                leading : Icon(Icons.logout),
                title : Text("Logout"),
                onTap: (){
                  logout(context);
                },
              )
            ],
          ),
        ),
        appBar:AppBar(
          title :Text("Contact Student"),
        ),
        body : FirestoreSearchScaffold(
          appBarBackgroundColor: Colors.white,
          firestoreCollectionName: 'old_student',
          searchBy: 'domaine',
          scaffoldBody: Center(),
          dataListFromSnapshot: OldStudentModel().dataListFromSnapshot,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<OldStudentModel>? dataList = snapshot.data;
              if (dataList!.isEmpty) {
                return const Center(
                  child: Text('Pas de resulat'),
                );
              }
              return ListView.builder(
                  itemCount: dataList.length,
                  itemBuilder: (context, index) {
                    final OldStudentModel data = dataList[index];

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(

                          title: Text('${data.domaine}',style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),),
                          subtitle: Text('${data.firstname} ${data.lastName}\n${data.description}\nContactez moi :\nPar e-mail  ${data.email} ou par telephone :  ${data.numberPhone}',style: TextStyle(
                            fontSize: 15,

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
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));  }

}


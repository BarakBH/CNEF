import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/profile_page_admin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import '../screens_user/registration_screen.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'add_someone.dart';
import 'all_meetings_view.dart';
import 'firestore_methods.dart';
import 'firestore_methods_2.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';
class AddEvent extends StatefulWidget {
  const AddEvent({Key? key}) : super(key: key);

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final moneyFormEditingController = new TextEditingController();
  final titleEditingController = new TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  Uint8List _file =Uint8List(1024);
  bool isLoading = false;

  UserModel loggedUser = UserModel();
  void postImage(String? uid,String? profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading

    // upload to storage and db
    String res = await FireStoreMethods2().uploadEvent(
      titleEditingController.text,
      moneyFormEditingController.text,
      _file,
      uid!,
      profImage!,

    );

  }
  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text('Create Event'),
        children: [
          SimpleDialogOption(
            padding : const EdgeInsets.all(20),
            child : const Text('Take a photo'),
            onPressed:() async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.camera,);
              setState(() {
                _file =file;
              });
            },
          ),
          SimpleDialogOption(
            padding : const EdgeInsets.all(20),
            child : const Text('Choose from your gallery'),
            onPressed:() async {
              Navigator.of(context).pop();
              Uint8List file = await pickImage(ImageSource.gallery,);
              setState(() {
                _file =file;
              });
            },
          ),
          SimpleDialogOption(
            padding : const EdgeInsets.all(20),
            child : const Text('Cancel'),
            onPressed:(){
              Navigator.of(context).pop();

            },
          )

        ],
      );
    });
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedUser = UserModel.fromMap(value.data());
      setState(() {

      });
    });
  }
  void dispose() {
    super.dispose();
    titleEditingController.dispose();
    moneyFormEditingController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final titleField = TextFormField(
        autofocus: false,
        controller: titleEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("Title is required for login");
          }
        },
        onSaved: (value) {
          titleEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Title Name",


        )
    );
    final moneyFormField =TextFormField(

      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "₪ PAF (optionnel)",
      ),
      style: TextStyle(

        color: Colors.black,
        fontSize: 25,
      ),
      validator: (value){
        if(value=='₪'|| value!.isEmpty){
          return ("Veuillez ecire un montant ");
        }
      },

      onChanged: (value) {
        moneyFormEditingController.text = value.toString();
      },
      onSaved: (value) {
        moneyFormEditingController.text = value!;
      },
      keyboardType: TextInputType.number,
    );
    final addEventButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),

      color: Colors.red,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(10, 10, 10, 10),
        minWidth: 140,
        onPressed: ()=>postImage(loggedUser.uid,"assets/user_image.png"),
        child : Text("Add event ", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
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
            title: Text("Ajouter un événement"), iconColor: Colors.red,
            textColor: Colors.red,

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
      title: Text("Ajouter un événement"),

    ),
      body :   SingleChildScrollView(
        child: Container(
        color: Colors.white,
        child: Padding(
        padding: const EdgeInsets.all(36.0),
    child: Form(
      child :
     Column(
            children:<Widget>[
              Center(
              child : IconButton(
            icon: const Icon(Icons.upload),
            onPressed: ()=>_selectImage(context),
          ),
              ),
              SizedBox(
                height: 200.0,
                width: 200.0,
                child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                        image:MemoryImage(_file),
                      ),
                    ),
                  ),
                ),
              SizedBox(height : 20),
              titleField,
              SizedBox(height : 20),
              moneyFormField,
              SizedBox(height : 30),
              addEventButton,

       ]
     ),
    ),
    ),
        ),
    ),
    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
}

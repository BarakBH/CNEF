
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/firestore_methods.dart';
import 'package:cnef_app/admin/profile_page_admin.dart';
import 'package:cnef_app/screens_user/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../model/admin_model.dart';
import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AboutUsAdmin.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';
import 'add_someone.dart';
import 'all_meetings_view.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';
class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  @override
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();
  Uint8List _file =Uint8List(1024);
  bool isLoading = false;

  final TextEditingController _descriptionController =TextEditingController();

  void postImage(String? uid,String? profImage) async {
    setState(() {
      isLoading = true;
    });
    // start the loading

      // upload to storage and db
      String res = await FireStoreMethods().uploadPost(
        _descriptionController.text,
        _file,
        uid!,
        profImage!,

      );

  }




  @override

  @override
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
  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text('Créer un post'),
        children: [
          SimpleDialogOption(
            padding : const EdgeInsets.all(20),
            child : const Text('Prendre une photo'),
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
            child : const Text('Choisir depuis la gallerie'),
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
            child : const Text('Annuler'),
            onPressed:(){
              Navigator.of(context).pop();

            },
          )

        ],
      );
    });
  }
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }


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
              iconColor: Colors.red,
              textColor: Colors.red,
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

        title: const Text(
          'Ajouter un post',
        ),
        centerTitle: false,
        actions: <Widget>[
          (_descriptionController.text!='')?
          TextButton(
            onPressed: ()=>postImage(loggedUser.uid,"assets/user_image.png"),
            child: const Text(
              "Post",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
          :TextButton(
        onPressed: (){},
        child: const Text(
          "Post",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0),
        ),
      )
        ],

      ),
      // POST FORM
       body: Column(
         children: <Widget>[
      //     isLoading
      //         ? const LinearProgressIndicator()
      //         : const Padding(padding: EdgeInsets.only(top: 0.0)),
      //     const Divider(),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceAround,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
               CircleAvatar(
                 backgroundImage: AssetImage(
                   'assets/user_image.png',
                 ),
               ),
               SizedBox(
                 width: MediaQuery.of(context).size.width * 0.45,
                 child: TextField(
                   controller: _descriptionController,
                  decoration: const InputDecoration(

                  hintText: "Ecriver une description...",
                       border: InputBorder.none),
                   maxLines: 8,
                 ),
               ),
               SizedBox(
                 height: 80.0,
                 width: 80.0,
                 child: AspectRatio(
                   aspectRatio: 487 / 451,
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
               ),

             ],
           ),

           Center(
               child:IconButton(
                 icon: const Icon(Icons.upload),
                 onPressed: ()=>_selectImage(context),
               )
           ),



    ],
    )
    );


  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
}

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user_model.dart';
import 'AboutUs_screen.dart';
import 'ContactStudent_screen.dart';
import 'FamiliesContact_screen.dart';
import 'Requestfund_screen.dart';
import 'faire_un_don_autre.dart';
import 'home_screen.dart';
import 'home_screen_general.dart';
class ProfilePageUser extends StatefulWidget {
  const ProfilePageUser({Key? key}) : super(key: key);

  @override
  _ProfilePageUserState createState() => _ProfilePageUserState();
}
pickImage(ImageSource source)async{
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source : source);
  if(_file != null){
    return await _file.readAsBytes();
  }
  print("No image selected");

}
class _ProfilePageUserState extends State<ProfilePageUser> {
  Uint8List _image =new Uint8List(1024) ;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
  void selectImage() async {
    Uint8List im= await pickImage(ImageSource.gallery);
    setState(() {
      _image =im;
    });
  }
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
    color: Colors.lightBlue,

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
            leading : Icon(Icons.account_circle_rounded),
            title : Text("Profil"),
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: ()=> {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfilePageUser())),
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

    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ContactStudent()))
    },
    ),
    // ListTile(
    //   leading : Icon(Icons.calendar_today),
    //   title : Text("Calendar"),
    //   onTap: ()=>{
    //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoadDataFromFireStore()))
    //   },
    // ),
    ListTile(
    leading : Icon(Icons.attach_money),
    title : Text("Request funds"),

    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RequestFunds()))
    },
    ),
    ListTile(
    leading : Icon(Icons.payment),
    title : Text("Don / Payer événement "),
    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FaireUnDon()))
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
    title :Text("Profile"),

    ),

    body: Container(
      padding: EdgeInsets.only(left: 16,top:20,right:16),
      child:ListView(
        children: [
          Center(
          child : Stack(
            children: [
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4,color:Colors.white),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 5,
                      color: Colors.black,
                      offset: Offset(0,10)
                    )
                  ],
                  image: DecorationImage(

                    fit:BoxFit.cover,
                   image:NetworkImage(
                     "${loggedInuser.file.toString()}",
                  )
                ),
              )
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                decoration: BoxDecoration(
                  color:Colors.lightBlue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 4,
                    color: Colors.white,
                  )
                ),
                height: 40,
                width: 40,
                child: FloatingActionButton(
                  child : Icon(Icons.edit,color:Colors.white),
                  onPressed: selectImage  ,
              )))
            ],
          )
          )
        ],
      )
    ),

    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';
import 'add_someone.dart';
import 'all_meetings_view.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';
class ProfilePageAdmin extends StatefulWidget {
  const ProfilePageAdmin({Key? key}) : super(key: key);

  @override
  _ProfilePageAdminState createState() => _ProfilePageAdminState();
}

class _ProfilePageAdminState extends State<ProfilePageAdmin> {
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final genderEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();

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
    final width = MediaQuery.of(context).size.width;
    const webScreenSize = 600;
    final List<String> genderItems = [
      'Homme',
      'Femme',
    ];
    final List<String> statusItems = [
      'Etudiant',
      'Sans emploi',
      'Employé',
    ];

    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("Ce champ est obligatoire");
          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },


        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            helperText: '${loggedUser.firstname}',
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Prénom",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final lastNameField = TextFormField(
        autofocus: false,
        controller: lastNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("Ce champ est obligatoire");
          }
        },
        onSaved: (value) {
          lastNameEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            helperText: '${loggedUser.lastName}',
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Nom",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final genderField = DropdownButtonFormField2(
      decoration: InputDecoration(
        helperText: '${loggedUser.gender}',
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: const Text(
        'Genre',
        style: TextStyle(fontSize: 14),
      ),

      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: genderItems
          .map((item) =>
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Merci de sélectionner votre genre';
        }
      },
      onChanged: (value) {
        genderEditingController.text = value!.toString();
        //Do something when changing the item if you want.
      },
      onSaved: (value) {
        genderEditingController.text = value!.toString();
      },
    );
    final numberPhoneField = TextFormField(
        autofocus: false,
        controller: phoneNumberEditingController,
        keyboardType: TextInputType.phone,
        validator: (value){
          if(value!.isEmpty){
            return ("NumberPhone is required for login");
          }
        },

        onSaved: (value) {
          phoneNumberEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            helperText: '${loggedUser.numberPhone}',
            prefixIcon: Icon(Icons.phone),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Numéro de téléphone",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )


    );
    final signModifs = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.redAccent,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){
          changeUser();
          Fluttertoast.showToast(msg: "Les modifs on bien ete enregistrees ");

        },
        child : Text("Enregistrer les changements", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
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
            iconColor: Colors.red,
            textColor: Colors.red,
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
        title :Text("Profil/Modifier son profil"),
        backgroundColor: Colors.redAccent,
      ),
        body: Container(
        padding: EdgeInsets.only(left: 16,top:20,right:16),
    child:ListView(
    children: [
    Center(
    child : Stack(
    children: [
      Padding(
        padding: EdgeInsets.all(25.0),
        child :Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              firstNameField,
              SizedBox(height: 20,),
              lastNameField,
              SizedBox(height: 20,),
              genderField,

              SizedBox(height: 20,),
              numberPhoneField,
              SizedBox(height: 20,),
              signModifs
            ],
          ),
        ),
      )
  ]
    ),),
    ]),
    )
    )
    ;
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
  void changeUser(){
    var collection = FirebaseFirestore.instance.collection('users');
    if(firstNameEditingController.text!='') {
      collection
          .doc('${loggedUser.uid}')
          .update({'firstName': firstNameEditingController.text});
    }
    if(lastNameEditingController.text!='') {
      collection
          .doc('${loggedUser.uid}')
          .update({'lastname': lastNameEditingController.text});
    }//
    if(genderEditingController.text!='') {
      collection
          .doc('${loggedUser.uid}')
          .update({'gender': genderEditingController.text});
    }//

    if(phoneNumberEditingController.text!='') {
      collection
          .doc('${loggedUser.uid}')
          .update({'numberPhone': phoneNumberEditingController.text});
    }//


  }
}

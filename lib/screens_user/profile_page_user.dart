import 'dart:typed_data';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/screens_user/login_screen.dart';
import 'package:cnef_app/screens_user/registration_screen.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../model/user_model.dart';
import 'AboutUs_screen.dart';
import 'ContactStudent_screen.dart';
import 'FamiliesContact_screen.dart';
import 'Requestfund_screen.dart';
import 'appointment_screen.dart';
import 'faire_un_don_autre.dart';
import 'home_screen.dart';
import 'home_screen_general.dart';
class ProfilePageUser extends StatefulWidget {
  const ProfilePageUser({Key? key}) : super(key: key);

  @override
  _ProfilePageUserState createState() => _ProfilePageUserState();
}

class _ProfilePageUserState extends State<ProfilePageUser> {
  Uint8List _file =Uint8List(1024);
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();

  final lastNameEditingController = new TextEditingController();
  final dateBirthEditingController = new TextEditingController();
  final genderEditingController = new TextEditingController();
  final yearOfAlyahEditingController = new TextEditingController();
  final statusEditingController = new TextEditingController();
  final idEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
  _selectImage(BuildContext context) async {
    return showDialog(context: context, builder: (context){
      return SimpleDialog(
        title: const Text('Create Post'),
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
        .then((value){
      loggedInuser = UserModel.fromMap(value.data());

        setState(() {

        });

       });

  }
  @override
  Widget build(BuildContext context) {
    final List<String> genderItems = [
      'Male',
      'Female',
    ];
    final List<String> statusItems = [
      'Student',
      'Jobless',
      'Employee',
    ];

    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("FirstName is required for login");
          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },


        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
          helperText: '${loggedInuser.firstname}',
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "First Name",
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
            return ("LastName is required for login");
          }
        },
        onSaved: (value) {
          lastNameEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            helperText: '${loggedInuser.lastName}',
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Last Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final genderField = DropdownButtonFormField2(
      decoration: InputDecoration(
        helperText: '${loggedInuser.gender}',
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
        'Select Your Gender',
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
          return 'Please select gender.';
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

    final dateBirthField = DateTimePicker(

      decoration: InputDecoration(
        helperText: '${loggedInuser.dateBirth}',
        hintText: "DateBirth",
        prefixIcon: Icon(Icons.date_range),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      initialValue: '',
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),

      validator: (value){

        if(value!.isEmpty){
          return ("DateBirth is required for login");
        }
      },
      onChanged: (value) {

        dateBirthEditingController.text = value.toString();
      },
      onSaved: (value) {
        dateBirthEditingController.text = value!.toString();
      },
    );
    final yearOfAlyahField = DateTimePicker(
      decoration: InputDecoration(
        helperText: '${loggedInuser.yearOfAlyah}',
        hintText: "Year of Alyah",
        prefixIcon: Icon(Icons.airplanemode_active),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),

      initialValue: '',
      firstDate: DateTime(1970),
      lastDate: DateTime(2100),
      dateLabelText: 'Date of your Alyah',

      validator: (value){
        if(value!.isEmpty){
          return ("YearOfALyah is required for login");
        }
      },
      onChanged: (value) {

        yearOfAlyahEditingController.text = value.toString();
      },
      onSaved: (value) {
        yearOfAlyahEditingController.text = value!.toString();
      },
    );
    final statusField = DropdownButtonFormField2(
      decoration: InputDecoration(
        helperText: '${loggedInuser.status}',
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        prefixIcon: Icon(Icons.man_rounded),
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
        'Select Your Status',
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
      items: statusItems
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
          return 'Selectionner statut';
        }
      },
      onChanged: (value) {

        statusEditingController.text = value.toString();
      },
      onSaved: (value) {
        statusEditingController.text = value!.toString();
      },

    );

    final idField = TextFormField(
        autofocus: false,
        controller: idEditingController,
        keyboardType: TextInputType.number,
        validator: (value){
          if(value!.isEmpty){
            return ("ID is required for login");
          }
        },

        onSaved: (value) {
          idEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            helperText: '${loggedInuser.id}',
            prefixIcon: Icon(Icons.person),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "ID number ",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
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
            helperText: '${loggedInuser.numberPhone}',
            prefixIcon: Icon(Icons.phone),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Number Phone",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )


    );
    final signModifs = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlue,
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
    title : Text("Menu"),

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
            leading : Icon(Icons.calendar_today),
            title : Text("RDV conseillère"),
            onTap: ()=>{
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Appointment()))
            },
          ),
    ListTile(
    leading : Icon(Icons.family_restroom),
    title : Text("Contacter Famille"),
    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FamiliesContact()))
    },
    ),

    ListTile(
    leading : Icon(Icons.contact_phone),
    title : Text("Contacter un(e) ancien(ne) étudiant(e)"),

    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ContactStudent()))
    },
    ),

    ListTile(
    leading : Icon(Icons.attach_money),
    title : Text("Demande spéciale"),

    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> RequestFunds()))
    },
    ),
    ListTile(
    leading : Icon(Icons.payment),
    title : Text("Faire un don/Payer événement"),
    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FaireUnDon()))
    },
    ),

    ListTile(
    leading : Icon(Icons.info_outline),
    title : Text("A propos de nous"),

    onTap: ()=>{
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AboutUs()))
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

    ),

    body: Container(
      padding: EdgeInsets.only(left: 16,top:20,right:16),
      child:ListView(
        children: [
          // Center(
          // child : Stack(
          //   children: [
          //     Container(
          //       width: 130,
          //       height: 130,
          //       decoration: BoxDecoration(
          //         shape: BoxShape.circle,
          //         border: Border.all(width: 4,color:Colors.white),
          //         boxShadow: [
          //           BoxShadow(
          //             spreadRadius: 2,
          //             blurRadius: 5,
          //             color: Colors.black,
          //             offset: Offset(0,10)
          //           )
          //         ],
          //         image: DecorationImage(
          //
          //           fit:BoxFit.cover,
          //          image:NetworkImage(
          //            "${loggedInuser.file.toString()}",
          //         )
          //       ),
          //     )
          //     ),
          //     Positioned(
          //         bottom: 0,
          //         right: 0,
          //         child: Container(
          //       decoration: BoxDecoration(
          //         color:Colors.lightBlue,
          //         shape: BoxShape.circle,
          //         border: Border.all(
          //           width: 4,
          //           color: Colors.white,
          //         )
          //       ),
          //       height: 40,
          //       width: 40,
          //       child: FloatingActionButton(
          //         child : Icon(Icons.add_a_photo,color:Colors.white),
          //         onPressed:(){  _selectImage(context); } ,
          //     ))),
          //
          //   ],
          // ),
          //
          // ),

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
                dateBirthField,
                SizedBox(height: 20,),
                yearOfAlyahField,
                SizedBox(height: 20,),
                statusField,
                SizedBox(height: 20,),
                idField,
                SizedBox(height: 20,),
                numberPhoneField,
                SizedBox(height: 20,),
                signModifs
              ],
            ),
          ),
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
  void changeUser(){
    var collection = FirebaseFirestore.instance.collection('users');
    if(firstNameEditingController.text!='') {
      collection
          .doc('${loggedInuser.uid}')
          .update({'firstName': firstNameEditingController.text});
    }
    if(lastNameEditingController.text!='') {
      collection
          .doc('${loggedInuser.uid}')
          .update({'lastname': lastNameEditingController.text});
    }//
    if(genderEditingController.text!='') {
      collection
          .doc('${loggedInuser.uid}')
          .update({'gender': genderEditingController.text});
    }//
    if(dateBirthEditingController.text!='') {
      collection
          .doc('${loggedInuser.uid}')
          .update({'dateBirth': dateBirthEditingController.text});
    }//
    if(idEditingController.text!='') {
      collection
          .doc('${loggedInuser.uid}')
          .update({'id': idEditingController.text});
    }//
    if(phoneNumberEditingController.text!='') {
      collection
          .doc('${loggedInuser.uid}')
          .update({'numberPhone': phoneNumberEditingController.text});
    }//
    if(statusEditingController.text!='') {
      collection
          .doc('${loggedInuser.uid}')
          .update({'status': statusEditingController.text});
    }//
    if(yearOfAlyahEditingController.text!='') {
      collection
          .doc('${loggedInuser.uid}')
          .update({'yearOfALyah': yearOfAlyahEditingController.text});
    }//

  }


}


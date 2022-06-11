import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/model/old_student_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';

class AddNewOldStudent extends StatefulWidget {
  const AddNewOldStudent({Key? key}) : super(key: key);

  @override
  _AddNewOldStudentState createState() => _AddNewOldStudentState();
}

class _AddNewOldStudentState extends State<AddNewOldStudent> {
  final _formKey = GlobalKey<FormState>();
  final emailEditingController = new TextEditingController();
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final domaineEditingController = new TextEditingController();
  final descriptionEditingController = new TextEditingController();
  final numberPhoneEditingController = new TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value){
      loggedUser = UserModel.fromMap(value.data());
    });
  }
  @override
  Widget build(BuildContext context) {
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
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Last Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value){
          if(value!.isEmpty)
          {
            return ("Please enter your email");

          }
          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
            return("Please Enter a valid email");

          }
          return null;
          //reg expression for email validation

        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            prefixIcon: Icon(Icons.mail),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final domaineField = TextFormField(
        autofocus: false,
        controller: domaineEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("FirstName is required for login");
          }
        },
        onSaved: (value) {
          domaineEditingController.text = value!;
        },


        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            prefixIcon: Icon(Icons.domain),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Domaine (en minuscule)",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final descriptionField= TextFormField(
      controller: descriptionEditingController,
      keyboardType: TextInputType.name,
      validator: (value){
        if(value==""){
          return ("Le champ est obligatoire");
        }

      },

      onSaved: (value) {
        descriptionEditingController.text = value!;
      },

      textInputAction: TextInputAction.next,
      decoration : InputDecoration(
          prefixIcon: Icon(Icons.text_fields),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Details...",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )

      ),
      maxLines: 7,
    );
    final numberPhoneField = TextFormField(
        autofocus: false,
        controller: numberPhoneEditingController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Le numero de telephone doit etre ajoute");
          }
        },

        onSaved: (value) {
          numberPhoneEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Numero de telephone ",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )


    );
    final Submit = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueGrey[300],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        onPressed: () {
          postDetailsToFireStore();
        },
        child: Text("Ajouter", textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold (
      appBar: AppBar
        (
        backgroundColor: Colors.blueGrey[300],
        title: Text("Ajouter un ancien etudiant"),
        automaticallyImplyLeading: false,

      ),
      body : SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            SizedBox(height: 20),
                            firstNameField,
                            SizedBox(height: 20),
                            lastNameField,
                            SizedBox(height: 20),
                            emailField,
                            SizedBox(height: 20),
                            domaineField,
                            SizedBox(height: 20),
                            numberPhoneField,
                            SizedBox(height: 20),
                           descriptionField,
                            SizedBox(height: 20),
                            Submit,

                          ]
                      )
                  )

              )
          )
      ),
    );
  }
  postDetailsToFireStore() async {
    //calling our firebase
    // calling our user model;
    // sedding the values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    OldStudentModel oldStudentModel = OldStudentModel();
    oldStudentModel.firstname = firstNameEditingController.text;
    oldStudentModel.lastName = lastNameEditingController.text;
    oldStudentModel.email = emailEditingController.text;
    oldStudentModel.numberPhone = numberPhoneEditingController.text;
    oldStudentModel.domaine = domaineEditingController.text;
    oldStudentModel.domaine = descriptionEditingController.text;

    if (_formKey.currentState!.validate()) {
      await firebaseFirestore
          .collection("old_student")
          .doc(oldStudentModel.firstname)
          .set(oldStudentModel.toMap());
      Fluttertoast.showToast(msg: "L'ancien(ne) etudiant(e)  a bien ete ajoute :)");
      Navigator.pop(context);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/model/family_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';

class AddNewFamily extends StatefulWidget {
  const AddNewFamily({Key? key}) : super(key: key);

  @override
  _AddNewFamilyState createState() => _AddNewFamilyState();
}

class _AddNewFamilyState extends State<AddNewFamily> {
  final _formKey = GlobalKey<FormState>();
  final locationEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final maxNumberPersonsEditingConroller = new TextEditingController();
  final numberPhoneEditingConroller = new TextEditingController();
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
    final lastNameField = TextFormField(
        autofocus: false,
        controller: lastNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("LastName is required for login");
          }
        },
        onSaved: (value) {
          lastNameEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.account_circle),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Last Name",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final locationField = TextFormField(
        autofocus: false,
        controller: locationEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Vous devez indiquer le lieu ");
          }
        },
        onSaved: (value) {
          locationEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.location_on),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Lieu ",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final numberPhoneField = TextFormField(
        autofocus: false,
        controller: numberPhoneEditingConroller,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Le numero de telephone doit etre joint");
          }
        },

        onSaved: (value) {
          numberPhoneEditingConroller.text = value!;
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
    final maxNumberPersonsField = TextFormField(
        autofocus: false,
        controller: maxNumberPersonsEditingConroller,
        keyboardType: TextInputType.number,
        // validator: (value){
        //   if(value!.isEmpty){
        //     return ("NumberPhone is required for login");
        //   }
        // },

        onSaved: (value) {
          maxNumberPersonsEditingConroller.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.maximize),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Nombre maximum de personnes a inviter (facultatif)",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )


    );
    final Submit = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightGreen[600],
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
        backgroundColor: Colors.lightGreen[600],
        title: Text("Ajouter une famille"),
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
                          lastNameField,
                          SizedBox(height: 20),
                          locationField,
                          SizedBox(height: 20),
                          numberPhoneField,
                          SizedBox(height: 20),
                          maxNumberPersonsField,
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
    FamilyModel familyModel = FamilyModel();
    familyModel.lastName = lastNameEditingController.text;
    familyModel.location = locationEditingController.text;
    familyModel.numberPhone = numberPhoneEditingConroller.text;
    familyModel.maxNumberPerson = maxNumberPersonsEditingConroller.text;

    if (_formKey.currentState!.validate()) {
      await firebaseFirestore
          .collection("family")
          .doc(familyModel.lastName)
          .set(familyModel.toMap());
      Fluttertoast.showToast(msg: "La famille a bien ete ajoutee :)");
      Navigator.pop(context);
    }
  }
}

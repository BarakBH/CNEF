
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/model/user_model.dart';
import 'package:cnef_app/screens_user/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../model/storage_methos.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}
pickImage(ImageSource source)async{
     final ImagePicker _imagePicker = ImagePicker();
     XFile? _file = await _imagePicker.pickImage(source : source);
     if(_file != null){
       return await _file.readAsBytes();
     }
     print("No image selected");

     }
class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  //our form key

  final _formKey = GlobalKey<FormState>();
  //editing Controller
  Uint8List _image =new Uint8List(1024) ;
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final dateBirthEditingController = new TextEditingController();
  final genderEditingController = new TextEditingController();
  final yearOfAlyahEditingController = new TextEditingController();
  final statusEditingController = new TextEditingController();
  final idEditingController = new TextEditingController();
  final phoneNumberEditingController = new TextEditingController();

  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();


  void selectImage() async {
   Uint8List im= await pickImage(ImageSource.gallery);
   setState(() {
      _image =im;
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
    //first name field
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
    final genderField = DropdownButtonFormField2(
      decoration: InputDecoration(
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
          return 'Please select gender.';
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
            prefixIcon: Icon(Icons.phone),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Number Phone",
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
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value){
          RegExp regex = new RegExp(r'^.{6,}$');
          if(value!.isEmpty){
            return ("Password is required for login");
          }
          if(!regex.hasMatch(value)){
            return ("Please Enter Valid Password (Min. 6chars)");
          }

        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        decoration : InputDecoration(
            prefixIcon: Icon(Icons.lock),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator:(value)
        {
          if( passwordEditingController.text != value)
            {
              return "Password don't match";
            }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        decoration : InputDecoration(
            prefixIcon: Icon(Icons.lock),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Confirm Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        )
    );


    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlue,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){
          signUp(emailEditingController.text,passwordEditingController.text);
        },
        child : Text("Sign Up", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );


    return Scaffold(
        backgroundColor: Colors.white,


        body: Center(
            child: SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                                children :<Widget>[
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                        radius: 64,
                                        backgroundImage: MemoryImage(_image),

                                      ),
                                      Positioned(
                                        bottom: 0,
                                        left: 75,
                                        child:IconButton(
                                          onPressed: selectImage,
                                          icon : const Icon(
                                            Icons.add_a_photo,
                                          )
                                        )

                                      )


                                    ],
                                  ),

                                  SizedBox(height : 45),
                                  firstNameField,
                                  SizedBox(height : 20),
                                  lastNameField,
                                  SizedBox(height : 20),
                                  genderField,
                                  SizedBox(height : 20),
                                  dateBirthField,
                                  SizedBox(height : 20),
                                  yearOfAlyahField,
                                  SizedBox(height : 20),
                                  statusField,
                                  SizedBox(height : 20),
                                  idField,
                                  SizedBox(height : 20),
                                  numberPhoneField,
                                  SizedBox(height : 20),
                                  emailField,
                                  SizedBox(height : 20),
                                  passwordField,
                                  SizedBox(height : 20),
                                  confirmPasswordField,
                                  SizedBox(height : 20),
                                  signUpButton,



                                ]

                            )
                        )

                    )
                )
            )
        )
    );






  }

  void signUp(String email,String password) async {
    if (_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password)
    .then((value)=>{
      postDetailsToFireStore(),

    }).catchError((e)
          {
            Fluttertoast.showToast(msg:e!.toString());
          });
  }
  }

  postDetailsToFireStore() async {
      //calling our firebase
      // calling our user model;
      // sedding the values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    UserModel userModel = UserModel();

   String photoURL = await StorageMethods().uploadImageToStorage('profilePics/',   _image, false);

    userModel.email =user!.email;
    userModel.uid = user.uid;
    userModel.file = photoURL;
    userModel.role="user";
    userModel.firstname = firstNameEditingController.text;
    userModel.lastName=lastNameEditingController.text;
    userModel.gender =genderEditingController.text;
    userModel.dateBirth =dateBirthEditingController.text;
    userModel.yearOfAlyah =yearOfAlyahEditingController.text;
    userModel.id =idEditingController.text;
    userModel.numberPhone=phoneNumberEditingController.text;
    userModel.status=statusEditingController.text;
    await firebaseFirestore
      .collection("users")
        .doc(user.uid)
          .set(userModel.toMap());

    Fluttertoast.showToast(msg: "Account created successfully :)");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);

  }

}

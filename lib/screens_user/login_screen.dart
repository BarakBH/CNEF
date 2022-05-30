
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/home_screen_admin.dart';
import 'package:cnef_app/screens_user/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' ;
import 'package:cnef_app/screens_user/registration_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../admin/login_screen_admin.dart';
import '../model/user_model.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //firebase
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user?.uid)
        .get()
        .then((value){
      loggedInuser = UserModel.fromMap(value.data());
      setState(() {

      });
    });
     }

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,

        //validator
        validator: (value){
          if(value!.isEmpty)
            {
              return ("Please enter your email");

            }
          if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
            return("Please Enter a valid email");

          }
            //reg expression for email validation

        },
        onSaved: (value) {
          emailController.text = value!;
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

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        //validator
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
          passwordController.text = value!;
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

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlue,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){ signIn(emailController.text,passwordController.text);


        },
        child : Text("Login", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.lightBlue,
            elevation:0,

        ),
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
                                  SizedBox(
                                      height :250,
                                      child : Image.asset(
                                        "assets/cnef_logo.jpg",
                                        fit : BoxFit.contain,
                                      )),
                                  SizedBox(height : 45),
                                  emailField,
                                  SizedBox(height : 25),
                                  passwordField,
                                  SizedBox(height : 35),
                                  loginButton,
                                  SizedBox(height: 15),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:<Widget>[
                                        Text("Vous n'avez pas de compte ? "),
                                        GestureDetector(onTap:(){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>RegistrationScreen(

                                          )));
                                        },
                                          child: Text("Sign Up",style: TextStyle(
                                            fontWeight:FontWeight.bold,
                                            fontSize:15,
                                            color : Colors.lightBlue,

                                          ),
                                          ),

                                        )

                                      ]

                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children:<Widget>[
                                        Text("\n"
                                            "Admin ? Entrez par cette porte : "),
                                        GestureDetector(onTap:(){
                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>LoginAdminScreen(

                                          )));
                                        },
                                          child: Text("\nPorte admin",style: TextStyle(
                                            fontWeight:FontWeight.bold,
                                            fontSize:15,
                                            color : Colors.red,


                                          ),
                                          ),

                                        )

                                      ]

                                  )

                                ]

                            )
                        )

                    )
                )
            )
        )
    );
  }
//login funciton

void signIn(String email, String password) async {

     if(_formKey.currentState!.validate()){

        await _auth.signInWithEmailAndPassword(email: email, password: password)
            .then((uid) =>
        {
          Fluttertoast.showToast(msg: "Login successful"),

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen())),

        }).catchError((e) {
          Fluttertoast.showToast(msg: e!.toString());
        });


        // await _auth.signInWithEmailAndPassword(email: email, password: password)
        //     .then((uid) =>
        // {
        //   Fluttertoast.showToast(msg: "Login successful"),
        //
        //   Navigator.of(context).pushReplacement(
        //       MaterialPageRoute(builder: (context) => HomeScreenAdmin())),
        //
        // }).catchError((e) {
        //   Fluttertoast.showToast(msg: e!.toString());
        // });




}
  }

}





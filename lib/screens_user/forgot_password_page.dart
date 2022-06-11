
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void dispose(){
    emailController.dispose();
  }
  @override
  Widget build(BuildContext context) {
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
    final resetButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.grey,
      child :MaterialButton(

        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){
            resetPassword();

        },
        child : Text("Reinitialiser le mot de passe", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        title: Text('Reinitialiser mot de passe'),
      ),
      body: Padding(
        padding:EdgeInsets.all(16) ,
        child : Form(
          key: _formKey,
          child : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Recevoir un email pour reinitialiser le mot de passe',textAlign: TextAlign.center,style: TextStyle(fontSize: 24),),
              SizedBox(height: 20),
              emailField,
              SizedBox(height: 20),
              resetButton,
            ],
          )
        ),
      )
    );
  }

  Future  resetPassword() async {
    showDialog(context: context, barrierDismissible: false,
    builder:(context)=>Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
          email: emailController.text.trim());
      Fluttertoast.showToast(
          msg: "L'email pour reinitialiser votre mot de passe a bien ete envoye");
      Navigator.of(context).popUntil((route) => route.isFirst) ;
    }on FirebaseAuthException catch(e){
      print(e);
      Fluttertoast.showToast(
          msg: "Erreur veuillez reessayer");
      Navigator.of(context).pop();
    }
  }
}

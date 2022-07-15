import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:cnef_app/model/user_model.dart' as model;

import '../model/inscription_event.dart';
import '../model/user_model.dart';
import 'firestore_methods.dart';
import 'firestore_methods_2.dart';
int check_validate =0;
const webScreenSize = 600;
const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
class EventCard extends StatefulWidget {
  final snap;
  const EventCard({
    Key? key,
    required this.snap,
  }) : super(key: key);

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  User? user = FirebaseAuth.instance.currentUser;
  final _auth = FirebaseAuth.instance;

  UserModel loggedUser = UserModel();
  int commentLen = 0;
  bool isLikeAnimating = false;
  final _formKey = GlobalKey<FormState>();
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();

  @override
  void initState() {
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



  deletePost(String postId) async {
    try {
      await FireStoreMethods2().deleteEvent(postId);
    } catch (err) {

    }
  }


  @override
  Widget build(BuildContext context) {

    User? user = FirebaseAuth.instance.currentUser;
    final width = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
      // boundary needed for web

      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),

                  ),
                ),
                loggedUser.role=='admin'
                    ?
                IconButton(
                  onPressed: () {
                    showDialog(
                      useRootNavigator: false,
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ].map(
                                    (e) =>
                                    InkWell(
                                        child: Container(
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 16),
                                          child: Text(e),
                                        ),
                                        onTap: () {
                                          deletePost(
                                            widget.snap['postId']
                                                .toString(),
                                          );
                                          // remove the dialog box
                                          Navigator.of(context).pop();
                                        }),
                              )
                                  .toList()),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                  color: Colors.white,
                )
                    : Container(),
              ],
            ),

          ),
          // IMAGE SECTION OF THE POST

            GestureDetector(

              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      widget.snap['postUrl'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),


                ],
              ),
            ),
          loggedUser.role=='user'
              ?
          TextButton(
              onPressed: inscrire,child:new Text("S'inscrire ",style: new TextStyle(
            color: Colors.white,
            fontSize: 16,

          ),)
          ):Text(""),



        ],
      ),
    );


  }
  Future<Null> inscrire() async {
    final firstNameField = TextFormField(
        autofocus: false,
        controller: firstNameEditingController,
        keyboardType: TextInputType.name,

        validator: (value){
          if(value!.isEmpty){
            return ("FirstName is required ");
          }
        },
        onSaved: (value) {
          firstNameEditingController.text = value!;
        },


        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "First Name",


        )
    );
    final lastNameField = TextFormField(

        autofocus: false,
        controller: lastNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value!.isEmpty){
            return ("LastName is required ");
          }
        },
        onSaved: (value) {
          lastNameEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Last Name",


        )
    );
    final validateButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),

      color: Colors.black,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(10, 10, 10, 10),
        minWidth: 140,
        onPressed: () {
          check_validate=1;
        },
        child : Text("Valider", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
    await showDialog(context: context,barrierDismissible: false, builder: (BuildContext buildcontext){
      return new AlertDialog(
        title: Text("Inscrivez vous ! \nPAF: ${widget.snap['PAF'].toString()}₪"),
        content : SingleChildScrollView(
                  child: Container(
                     color: Colors.white,

                      child: Form(
                        key: _formKey,
                      child: Column(
                          children :<Widget>[
                        SizedBox(height : 45),
                        firstNameField,
                        SizedBox(height : 20),
                        lastNameField,
                        SizedBox(height : 20),
                        validateButton,
                        ]
                      )
      )
      )
      )




      );
    });

    postDetailsToFireStore();

  }

  postDetailsToFireStore() async {
    //calling our firebase
    // calling our user model;
    // sedding the values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    InscriptionEventModel inscriptionEventModel = InscriptionEventModel();
    inscriptionEventModel.uid = user!.uid;
    inscriptionEventModel.firstName = firstNameEditingController.text;
    inscriptionEventModel.lastName = lastNameEditingController.text;
    inscriptionEventModel.title =  widget.snap['title'].toString();
    if (_formKey.currentState!.validate()) {
      await firebaseFirestore
          .collection("inscription_event")
          .doc(user.uid)
          .set(inscriptionEventModel.toMap());
      Fluttertoast.showToast(msg: "L'inscription a ete effectuee  :)");
      Navigator.pop(context);
    }
  }


}


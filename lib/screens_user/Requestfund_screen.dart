

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/screens_user/login_screen.dart';
import 'package:cnef_app/screens_user/profile_page_user.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cnef_app/screens_user/FamiliesContact_screen.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/request_user_model.dart';
import '../model/user_model.dart';
import '../rendezvous_conseillere/main2.dart';
import 'AboutUs_screen.dart';
import 'ContactStudent_screen.dart';
import 'faire_un_don_autre.dart';
import 'home_screen.dart';
import 'home_screen_general.dart';
bool check = true;
String? s ;

class RequestFunds extends StatefulWidget {
  const RequestFunds({Key? key}) : super(key: key);

  @override
  _RequestFundsState createState() => _RequestFundsState();
}

class _RequestFundsState extends State<RequestFunds> {
  int countImg=0;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final _auth = FirebaseAuth.instance;

  List<UploadTask> uploadedTasks = [];
  List<File> selectedFiles = [];
// Select files to be uploaded to Storage

  Future selectFileTo() async {
    try {
      final result = await FilePicker.platform.pickFiles(allowMultiple: true);
      if (result != null) {
         for (var selectedFile in result.files) {
           File file = File(selectedFile.path ?? '');
           selectedFiles.add(file);
         }
         Fluttertoast.showToast(msg: "${selectedFiles.first.toString()}");
      } else {
        print("User has cancelled the selection");
      }
    } catch (e) {
      print(e);
    }
  } // Upload selected files to Storage

  uploadFileToStorage(File file) {

    UploadTask task = _firebaseStorage
        .ref("file")
        .child("fichier${countImg.toString()}")
        .putFile(file);
    countImg++;
    return task;
  }
  // Save files to Storage and get files Urls

  saveImageUrlToFirebase(UploadTask task) {
    task.snapshotEvents.listen((snapShot) {
      if (snapShot.state == TaskState.success) {
        snapShot.ref.getDownloadURL().then((urls) =>
            writeUrltoFirestore(urls));
      }
    });
  }
  writeUrltoFirestore(urls) async {
    Map<String, dynamic> firestoredocData = {
      "url": urls, // HERE I HAVE TO STORE ARRAY OF URLS FROM STORAGE
    };
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
     RequestUserModel requestModel = RequestUserModel();

     if(check==false ) {
         s= s.toString()+" "+firestoredocData.values.first.toString();
     } else {
       requestModel.listFile=firestoredocData.values.first.toString();
       s=requestModel.listFile.toString()+" ";
       check=false;
     }
     requestModel.uid = user?.uid;
     requestModel.description=descriptionEditingController.text;
     requestModel.montant = moneyFormEditingController.text;
    requestModel.listFile=s;
    await firebaseFirestore
        .collection("request_users")
        .doc(user?.uid)
        .set(requestModel.toMap());
  }


  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
  final descriptionEditingController= new TextEditingController();
  final moneyFormEditingController = new TextEditingController();
  final fileURL = new TextEditingController();
  final _formKey2 = GlobalKey<FormState>();

  @override
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
    final fileURLField =
        Column( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: selectFileTo,
                            icon: const Icon(
                              Icons.attach_file,
                              size: 30,
                              color: Colors.grey,
                            )),
                      ],
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
          hintText: "Bonjour j'aimerai faire une demande d'argent car...  ",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),

          )

      ),
      maxLines: 7,
    );
    final moneyFormField =TextFormField(
     initialValue: "₪",
      style: TextStyle(
        fontSize: 25,
      ),
      validator: (value){
        if(value=='₪'|| value!.isEmpty){
          return ("Veuillez ecire un montant ");
        }
      },
      onChanged: (value) {
        moneyFormEditingController.text = value.toString();
      },
      onSaved: (value) {
        moneyFormEditingController.text = value!;
      },
      keyboardType: TextInputType.number,
    );

    final Submit = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: addData,
        child : Text("Submit", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
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
              title : Text("Home"),

              onTap: ()=> {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen())),
              },
            ),
            ListTile(
              leading : Icon(Icons.account_circle_rounded),
              title : Text("Profil"),
              onTap: ()=> {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfilePageUser())),
              },
            ),
            //salut
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
              iconColor: Colors.red,
              textColor: Colors.red,
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

      body: SingleChildScrollView(
          child: Container(
              color: Colors.white,
              child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Form(
                      key: _formKey2,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            Text("Demande d'argent",
                              style : TextStyle(
                                color:Colors.black,
                                fontSize: 25,
                              ),

                            ),
                            SizedBox(height : 20),
                            fileURLField,
                            SizedBox(height : 20),
                            descriptionField,
                            SizedBox(height : 20),
                            moneyFormField,
                            SizedBox(height : 20),
                            Submit,

                          ]
                      )
                  )

              )
          )
      ),
      appBar:AppBar(
        title :Text("Request Funds"),
      ),


    );

  }

  addData() async {
    s="";
    countImg=0;
    if (_formKey2.currentState!.validate()) {
      for (var file in selectedFiles) {
        final UploadTask task = uploadFileToStorage(file);
        saveImageUrlToFirebase(task);
        setState(() {
          uploadedTasks.add(task);
        });
      }

      Fluttertoast.showToast(
          msg: "Vous avez envoye(e) ${countImg.toString()} fichiers");

      Navigator.pop(context);
    }
  }

  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
}

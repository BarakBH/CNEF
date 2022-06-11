
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/screens_user/profile_page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/user_model.dart';
import 'AboutUs_screen.dart';
import 'ContactStudent_screen.dart';
import 'FamiliesContact_screen.dart';
import 'Requestfund_screen.dart';
import 'home_screen.dart';
import 'home_screen_general.dart';
class FaireUnDon extends StatefulWidget {
  const FaireUnDon({Key? key}) : super(key: key);

  @override
  _FaireUnDonState createState() => _FaireUnDonState();
}

class _FaireUnDonState extends State<FaireUnDon> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();

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
    final Submit = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.lightBlue[600],
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        onPressed: (){
          final Uri _url = Uri.parse('http://paypal.me/chabbathevron2021');
            launchUrl(_url);

        },
        child: Text("Payer", textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ),
    );
    double c_width = MediaQuery.of(context).size.width*1;

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
              iconColor: Colors.red,
              textColor: Colors.red,
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
        title :Text("Faire un don/Payer événement"),
      ),


    body:Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Form(

                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children:<Widget>[
                          Text("Effectuer un don ou le paiement d'un événement en saisissant le mail suivant : info@cnef.org ainsi que le montant.",

                            style : TextStyle(
                              color:Colors.black,
                              fontSize: 25,
                            ),
                            textAlign: TextAlign.center,

                          ),

                          SizedBox(height : 50),
                          Submit,

                        ]
                    )
                )

            )
        )

    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));  }
}


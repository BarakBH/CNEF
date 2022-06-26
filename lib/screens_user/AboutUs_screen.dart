import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/screens_user/home_screen_general.dart';
import 'package:cnef_app/screens_user/login_screen.dart';
import 'package:cnef_app/screens_user/profile_page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cnef_app/screens_user/FamiliesContact_screen.dart';
import 'package:flutter/services.dart';

import '../model/user_model.dart';
import '../rendezvous_conseillere/main2.dart';
import 'ContactStudent_screen.dart';
import 'Requestfund_screen.dart';
import 'appointment_screen.dart';
import 'faire_un_don_autre.dart';
import 'home_screen.dart';
class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
    final List<String> imgList = [
      "assets/event1_cnef.jpg",
    ];
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
              title : Text("Menu"),

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
              iconColor: Colors.red,
              textColor: Colors.red,
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
        title :Text("A propos de nous"),
      ),
        body : SingleChildScrollView(
          child : new Container (
          padding: const EdgeInsets.all(16.0),
           width: c_width,
            child: new Column (

            children: <Widget>[
            Text ("Fondé en 1987, le CNEF est une association encourageant a l’Alya qui a pour but d’accueillir, encadrer, orienter et aider les jeunes francophones dans leur intégration en Israël.\n"
                "\nLe CNEF intervient depuis l’aide à l’élaboration du projet d’Alya jusqu’à l’aide à l’intégration sociale, académique et culturelle en Israël.\n\nGrace à son action, le CNEF est reconnu comme l’organisme de référence dans l’aide et l’intégration des étudiants et jeunes francophones venant s’installer en Israël.\n\nLe CNEF propose un service professionnel gratuit d’information et de conseils personnalisés pré et post Alya dans plusieurs domaines:\n\n• Département études: programmes d’intégration pour jeunes olim francophones, possibilités d’études en Israël, équivalences de diplômes/poursuites d’études\n\n• Département armée/ Volontariat Civil\n\n•Département administration: droits administratifs du nouvel immigrant.\n\nLe CNEF attribue des bourses au cas par cas et selon le budget aux étudiants les plus nécessiteux.\n\nTout au long de l’année sont organisés des activités, des shabbat pleins, des conférences et soirées culturelles, des excursions.\n\nLe CNEF compte plus de 1000 jeunes actuellement repartis dans tout le pays.\n\nLe CNEF, c’est une équipe de 5 professionnels et 30 bénévoles dirigés par Sam Kadosh, présents dans tout Israël et sur les différents campus universitaires.\n\nNos locaux sont situes a Jérusalem. Nous recevons sur rdv. \n\nVous pouvez nous contacter par tel: 026222625, par mail: info@cnef.org ou \nsur WhatsApp: 0584222526.\n\n Nous avons également un site internet www.cnef.org , une page et un groupe facebook (CNEF-centre national des etudiants francophones) ainsi qu’un compte Instagram (cnef_israel) actifs.",style: TextStyle(
              fontSize: 18,
            ),),

            ]

                ),

          ),


        ),
    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));  }
}

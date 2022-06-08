import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/add_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AddPost.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';
class AboutUsAdminScreen extends StatefulWidget {
  const AboutUsAdminScreen({Key? key}) : super(key: key);

  @override
  _AboutUsAdminScreenState createState() => _AboutUsAdminScreenState();
}

class _AboutUsAdminScreenState extends State<AboutUsAdminScreen> {
  @override
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();
  @override
  void initState() {
    // TODO: implement initState
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
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
  Widget build(BuildContext context) {
    double c_width = MediaQuery.of(context).size.width*1;

    return Scaffold(

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                  "${loggedUser.firstname.toString()} ${loggedUser.lastName
                      .toString()}"),
              accountEmail: Text("${loggedUser.email}"),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Image.asset(
                    "assets/user_image.png",


                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey,

              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Home"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreenAdmin())),
              },
            ),
            ListTile(
              leading: Icon(Icons.web),
              title: Text("DataBase"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DataBaseScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add Post"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddPostScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add Event"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEvent()))
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_phone),
              title: Text("All Requests"),

              onTap: () =>
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllRequestsScreen()))
              },
            ),

            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About us "),
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () =>
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutUsAdminScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Logout"),
              onTap: () {
                logout(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("About Us "),

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
}

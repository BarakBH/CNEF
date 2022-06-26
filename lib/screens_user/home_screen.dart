
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/chat_screens/chat_detail.dart';
import 'package:cnef_app/chat_states/home_page_user_chat.dart';
import 'package:cnef_app/screens_user/profile_page_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cnef_app/screens_user/FamiliesContact_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../admin/event_card.dart';
import '../admin/post_card.dart';
import '../chat_screens/people_user.dart';
import '../chat_states/home_page_chat.dart';
import '../model/user_model.dart';
import '../rendezvous_conseillere/main2.dart';
import 'AboutUs_screen.dart';
import 'ContactStudent_screen.dart';
import 'Requestfund_screen.dart';
import 'appointment_screen.dart';
import 'faire_un_don_autre.dart';
import 'home_screen_general.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
 // static int num =0;
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
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
      "cnef_logo",
    ];
    final width = MediaQuery.of(context).size.width;
    const webScreenSize = 600;
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
              iconColor: Colors.red,
              textColor: Colors.red,
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
            // ListTile(
            //   leading : Icon(Icons.calendar_today),
            //   title : Text("Calendar"),
            //   onTap: ()=>{
            //     Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LoadDataFromFireStore()))
            //   },
            // ),
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

      title :Text("A LA UNE"),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) =>
                TextButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  //tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,

                  child : Text(
                    "Evénements",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0
                    ),

                  ),
                ),
          ),
        ],

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue,
        child : Badge(
          padding: EdgeInsets.all(6),
          badgeColor: Colors.redAccent,
          toAnimate: false,
          showBadge:loggedInuser.badge_message==0?false :true,
          position: BadgePosition.bottomEnd(bottom: 24,end: -15),
          badgeContent: Text('${loggedInuser.badge_message}',textAlign:TextAlign.center,style: TextStyle(
            fontSize: 14,

            color: Colors.white ,
            fontWeight: FontWeight.bold,
          ),),
          child : Icon(Icons.chat_sharp)

        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomePageChatUser()));

        },
      ),

      body : StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(

            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCard(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );

        },
      ),
      endDrawer :
      StreamBuilder(
        stream: FirebaseFirestore.instance.collection('events').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return CarouselSlider.builder(

            options: CarouselOptions(
              height: MediaQuery.of(context).size.width,
              viewportFraction: 1.0,
              enlargeCenterPage: true,

              // autoPlay: false,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index,momo) =>
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: width > webScreenSize ? width * 0.3 : 0,
                    vertical: width > webScreenSize ? 15 : 0,
                  ),
                  child: EventCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                ),
          );
        },

      ),



    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }

}



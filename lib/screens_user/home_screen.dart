
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cnef_app/screens_user/FamiliesContact_screen.dart';
import 'package:flutter/services.dart';

import '../admin/post_card.dart';
import '../chat_states/home_page_chat.dart';
import '../model/user_model.dart';
import '../rendezvous_conseillere/main2.dart';
import 'AboutUs_screen.dart';
import 'ContactStudent_screen.dart';
import 'Requestfund_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
                color: Colors.blueGrey,

              ),
              ),
            ListTile(
              leading : Icon(Icons.home),
              title : Text("Home"),
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: ()=> {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen())),
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

      title :Text("                 A la une"),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amberAccent,
        child : Icon(Icons.chat_sharp),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomePage()));

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
      CarouselSlider(

        options: CarouselOptions(
          height: MediaQuery.of(context).size.width,
          viewportFraction: 1.0,
          enlargeCenterPage: true,

          // autoPlay: false,
        ),
        items: imgList
            .map((item) => Container(
          child : Center(
              child: Image.asset(
                item,
                fit: BoxFit.cover,

              )),
        ))
            .toList(),
      ),

    );
  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}



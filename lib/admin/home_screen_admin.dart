import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/AboutUsAdmin.dart';
import 'package:cnef_app/admin/AddPost.dart';
import 'package:cnef_app/admin/add_someone.dart';
import 'package:cnef_app/admin/appointment_screen_admin.dart';
import 'package:cnef_app/admin/event_card.dart';
import 'package:cnef_app/admin/post_card.dart';
import 'package:cnef_app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../chat_states/home_page_chat.dart';
import '../screens_user/home_screen_general.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';

class HomeScreenAdmin extends StatefulWidget {
  const HomeScreenAdmin({Key? key}) : super(key: key);

  @override
  _HomeScreenAdminState createState() => _HomeScreenAdminState();
}

class _HomeScreenAdminState extends State<HomeScreenAdmin> {
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
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const webScreenSize = 600;

    return Scaffold(

      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text("${loggedUser.firstname.toString()} ${loggedUser.lastName.toString()}"),
              accountEmail: Text("${loggedUser.email}"),
              currentAccountPicture: CircleAvatar(
                child : ClipOval(
                  child : Image.asset(
                    "assets/user_image.png",



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
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreenAdmin())),
              },
            ),
            ListTile(
              leading : Icon(Icons.web),
              title : Text("DataBase"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DataBaseScreen()))
              },
            ),
            ListTile(
              leading : Icon(Icons.add),
              title : Text("Add Post"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddPostScreen()))
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
              leading: Icon(Icons.add),
              title: Text("Add Someone"),
              onTap: () =>
              {
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddSomeone()))
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today_outlined),
              title: Text("Rendez-vous-Conseillere"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AppointmentScreen()))
              },
            ),
            ListTile(
              leading : Icon(Icons.contact_phone),
              title : Text("All Requests"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AllRequestsScreen()))
              },
            ),

            ListTile(
              leading : Icon(Icons.info_outline),
              title : Text("About us "),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AboutUsAdminScreen()))
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
        backgroundColor:Colors.redAccent,
        title :Text("Home"),

      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child : Icon(Icons.chat_sharp),
        onPressed: (){
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
                    horizontal: width > webScreenSize ? width * 0.29 : 0,
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

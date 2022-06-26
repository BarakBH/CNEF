import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/AboutUsAdmin.dart';
import 'package:cnef_app/admin/AddPost.dart';
import 'package:cnef_app/admin/add_someone.dart';
import 'package:cnef_app/admin/all_meetings_view.dart';
import 'package:cnef_app/admin/event_card.dart';
import 'package:cnef_app/admin/post_card.dart';
import 'package:cnef_app/admin/profile_page_admin.dart';
import 'package:cnef_app/model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../chat_states/home_page_chat.dart';
import '../screens_user/home_screen_general.dart';
import 'AllRequests.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';
import 'login_screen_admin.dart';

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
      check();
      setState(() {

      });
    });
  }
  void check () async{
    if(loggedUser.role=='user'){
      SystemNavigator.pop();
    }
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
              title : Text("Menu"),
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: ()=> {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreenAdmin())),
              },
            ),
            ListTile(
              leading : Icon(Icons.account_circle_rounded),
              title : Text("Profil"),
              onTap: ()=> {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ProfilePageAdmin())),
              },
            ),
            ListTile(
              leading : Icon(Icons.web),
              title : Text("Users/Admins"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DataBaseScreen()))
              },
            ),

            ListTile(
              leading : Icon(Icons.add),
              title : Text("Ajouter un post"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AddPostScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Ajouter un événement"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddEvent()))
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Ajouter ancien étudiant/famille"),
              onTap: () =>
              {
              Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddSomeone()))
              },
            ),
            ListTile(
              leading : Icon(Icons.calendar_today),
              title : Text("RDV conseillère/Autorisations"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AllMeetingsView()))
              },
            ),
            ListTile(
              leading : Icon(Icons.contact_phone),
              title : Text("Toutes les demandes"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AllRequestsScreen()))
              },
            ),

            ListTile(
              leading : Icon(Icons.info_outline),
              title : Text("A propos de nous"),
              onTap: ()=>{
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> AboutUsAdminScreen()))
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
        backgroundColor: Colors.red,
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
        backgroundColor: Colors.redAccent,
        child : Badge(
            padding: EdgeInsets.all(6),
            badgeColor: Colors.redAccent,
            toAnimate: false,
            showBadge:loggedUser.badge_message==0?false :true,
            position: BadgePosition.bottomEnd(bottom: 24,end: -15),
            badgeContent: Text('${loggedUser.badge_message}',textAlign:TextAlign.center,style: TextStyle(
              fontSize: 14,

              color: Colors.white ,
              fontWeight: FontWeight.bold,
            ),),
            child : Icon(Icons.chat_sharp)

        ),
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

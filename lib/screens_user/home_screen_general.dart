import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/screens_user/login_screen.dart';
import 'package:flutter/material.dart';

import 'package:cnef_app/admin/post_card.dart';

import '../admin/event_card.dart';
import '../admin/event_card_2.dart';
import '../admin/post_card.dart';
import '../admin/post_card2.dart';

class HomeScreenGeneral extends StatefulWidget {
  const HomeScreenGeneral({Key? key}) : super(key: key);

  @override
  _HomeScreenGeneralState createState() => _HomeScreenGeneralState();
}

class _HomeScreenGeneralState extends State<HomeScreenGeneral> {
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("posts").
        get();
    // FirebaseFirestore.instance
    //     .collection("events").
    // get();


  }
    @override
  Widget build(BuildContext context) {
     final width = MediaQuery
          .of(context)
          .size
          .width;
      const webScreenSize = 600;
      return Scaffold(
        drawer: Drawer(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Menu"),
                onTap: () =>
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => HomeScreenGeneral()))
                },
              ),
              ListTile(
                leading: Icon(Icons.login),
                title: Text("Se connecter/S'enregistrer"),
                onTap: () =>
                {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LoginScreen()))
                },
              ),

            ],
          ),
        ),
        appBar: AppBar(
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
                          fontSize: 20.0
                      ),

                    ),
                  ),
            ),
          ],
          leading: Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.home),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
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

              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) => Container(
                margin: EdgeInsets.symmetric(
                  horizontal: width > webScreenSize ? width * 0.3 : 0,
                  vertical: width > webScreenSize ? 15 : 0,
                ),
                child: PostCard2(
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
            if(snapshot.hasData) {
              return CarouselSlider.builder(

                options: CarouselOptions(
                  height: MediaQuery
                      .of(context)
                      .size
                      .width,
                  viewportFraction: 1.0,
                  enlargeCenterPage: true,

                  // autoPlay: false,
                ),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index, momo) =>

                    Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0,
                      ),
                      child: EventCard2(
                        snap: snapshot.data!.docs[index].data(),
                      ),
                    ),
              );
            }
            else if (snapshot.hasError) {
              return Text('Error!');
            } else {
              return Container();
            }
          },

        ),
      );
    }


}

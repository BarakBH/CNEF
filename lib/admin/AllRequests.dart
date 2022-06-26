import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/profile_page_admin.dart';
import 'package:cnef_app/model/request_user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:syncfusion_flutter_core/theme.dart';

import '../model/user_model.dart';
import '../screens_user/home_screen_general.dart';
import 'AboutUsAdmin.dart';
import 'AddPost.dart';
import 'DataBaseScreen.dart';
import 'add_event.dart';
import 'add_someone.dart';
import 'all_meetings_view.dart';
import 'home_screen_admin.dart';
import 'login_screen_admin.dart';
List<DocumentSnapshot> ?documents_requests;
List<DocumentSnapshot> ?documents_requests2;

class AllRequestsScreen extends StatefulWidget {
  const AllRequestsScreen({Key? key}) : super(key: key);

  @override
  _AllRequestsScreenState createState() => _AllRequestsScreenState();
}
final database1 = FirebaseFirestore.instance;
Future<QuerySnapshot> years = database1.collection('request_users').get();
final database2 = FirebaseFirestore.instance;
Future<QuerySnapshot> years2 = database2.collection('invitation_user').get();
class _AllRequestsScreenState extends State<AllRequestsScreen> {
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

  @override
  Widget build(BuildContext context) {
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
                color:Colors.blueGrey,

              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("Menu"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HomeScreenAdmin())),
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
              leading: Icon(Icons.web),
              title: Text("Users/Admins"),

              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => DataBaseScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Ajouter un post"),
              onTap: () =>
              {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddPostScreen()))
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
                    MaterialPageRoute(builder: (context) => AddSomeone()))
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
              leading: Icon(Icons.contact_phone),
              title: Text("Toutes les demandes"),
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: () =>
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AllRequestsScreen()))
              },
            ),

            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("A propos de nous"),
              onTap: () =>
              {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AboutUsAdminScreen()))
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Se déconnecter"),
              onTap: () {
                logout(context);
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        title: Text("Toutes les demandes"),

      ),

      body :
      FirestoreSearchScaffold(
      appBarBackgroundColor: Colors.white,
      firestoreCollectionName: 'request_users',
      searchBy: 'firstName',
      scaffoldBody: Center(),
      dataListFromSnapshot: RequestUserModel().dataListFromSnapshot,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<RequestUserModel>? dataList = snapshot.data;
          if (dataList!.isEmpty) {
            PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();
            return RefreshIndicator(
              child: PaginateFirestore(
                itemBuilder: (context, documentSnapshots, index) {
                  final data = documentSnapshots[index].data() as Map?;
                  return ListTile(

                    title: data==null ? Text('Error in data') : Text(data['firstName']+" "+data['lastName'],style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    subtitle: data==null?Text('Error in data'): Text( data['description']+"\n"+"Montant:"+data['montant'])
                    ,


                  );
                } ,
                // orderBy is compulsary to enable pagination
                query: FirebaseFirestore.instance.collection('request_users').orderBy('firstName'),
                listeners: [
                  refreshChangeListener,
                ], itemBuilderType: PaginateBuilderType.listView,

              ),
              onRefresh: () async {
                refreshChangeListener.refreshed = true;
              },
            );
          }
          return ListView.builder(
              itemCount: dataList.length,
              itemBuilder: (context, index) {
                final RequestUserModel data = dataList[index];

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(

                      title: Text('${data.firstName} ${data.lastName}',style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),),
                      subtitle:Text('${data.description} \nMontant: ${data.montant}'),
                )
                      ,


                  ],
                );
              });
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasData) {
            return const Center(
              child: Text('Aucun résultat retourné'),
            );
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    )
    );
  }

}

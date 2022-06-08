
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cnef_app/model/invitation_user_model.dart';
import 'package:cnef_app/screens_user/login_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';

import '../model/user_model.dart';
import '../rendezvous_conseillere/main2.dart';
import 'AboutUs_screen.dart';
import 'ContactStudent_screen.dart';
import 'Requestfund_screen.dart';
import 'home_screen.dart';
import 'home_screen_general.dart';
class FamiliesContact extends StatefulWidget {
  const FamiliesContact({Key? key}) : super(key: key);

  @override
  _FamiliesContactState createState() => _FamiliesContactState();
}

class _FamiliesContactState extends State<FamiliesContact> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final status_religionEditingController = new TextEditingController();
  final descriptionEditingController= new TextEditingController();
  final locationEditingConroller = new TextEditingController();

  DateFormat ?dateFormat;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInuser = UserModel();
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

    final List<String> statusReligionItems = [
      'Dati',
      'Haredi',
      'Hiloni',
    ];
    final List<String> locationsIsrael = [
      'Peu importe',
      'Jerusalem',
      'Tel Aviv',
      'Natanya',
      'Hadera',
      'Ashdod',
      'Haifa',
      'Judee Samarie',
      'Region Sud',
      'Region Nord',
      'Region Centre',

    ];

    final status_religionField = DropdownButtonFormField2(

      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.

        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: const Text(
        'Select Your Religion Status',
        style: TextStyle(fontSize: 14),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonWidth: 99,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: statusReligionItems
          .map((item) =>
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select tour status religion.';
        }
        return null;
      },
      onChanged: (value) {
        status_religionEditingController.text = value.toString();
      },
      onSaved: (value) {
        status_religionEditingController.text = value!.toString();
      },

    );

    final locationField =DropdownButtonFormField2(

      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        prefixIcon: Icon(
          Icons.location_on,
          size: 30,
        ),
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: const Text(
        'Selectionnez un endroit pour sejourner ',
        style: TextStyle(fontSize: 14),
      ),
      icon: const Icon(
        Icons.arrow_drop_down,
        color: Colors.black45,
      ),
      iconSize: 30,
      buttonHeight: 60,
      buttonWidth: 99,
      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
      dropdownDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
      ),
      items: locationsIsrael
          .map((item) =>
          DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select a location.';
        }
        return null;
      },
      onChanged: (value) {
        locationEditingConroller.text = value.toString();
      },
      onSaved: (value) {
        locationEditingConroller.text = value!.toString();
      },

    );

    final descriptionField= TextFormField(
        autofocus: false,
        controller: descriptionEditingController,
        keyboardType: TextInputType.name,
        validator: (value){
          if(value==""){
            return ("Description is required");
          }
        },
        onSaved: (value) {
          descriptionEditingController.text = value!;
        },

        textInputAction: TextInputAction.next,
        decoration : InputDecoration(
            prefixIcon: Icon(Icons.text_fields),
            contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
            hintText: "Hello, I would like to be invited to someone's house for this Shabbat.  ",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            )

        ),
      maxLines: 7,
    );
    final Submit = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.green,
      child :MaterialButton(
        padding : EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed:(){
          postDetailsToFireStore();
        },
        child : Text("Submit", textAlign: TextAlign.center,style:TextStyle(fontSize: 20,color: Colors.white,fontWeight: FontWeight.bold)),
      ),
    );
    //date
    DateTime day =DateTime.now();
    var strDay =DateFormat('EEEE').format(DateTime.now()).toString();
      if(strDay=='Sunday')  {
          day =day.add(const Duration(days:6));
      }
   else if(strDay=='Monday'){
        day =day.add(const Duration(days:5));
      }
     else if (strDay=='Tuesday'){
        day =day.add(const Duration(days:4));
      }
      else if  (strDay=='Wednesday'){
        day =day.add(const Duration(days:3));
      }
     else if (strDay=='Thursday'){
        day =day.add(const Duration(days:2));

      }
    else if (strDay=='Friday'){
        day =day.add(const Duration(days:1));

      }

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

              onTap: ()=> {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> HomeScreen())),

              },
            ),
            ListTile(
              leading : Icon(Icons.family_restroom),
              title : Text("Families Contact"),
              iconColor: Colors.red,
              textColor: Colors.red,
              onTap: ()=>FamiliesContact(),
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
         body: SingleChildScrollView(
                child: Container(
                    color: Colors.white,
                    child: Padding(
                        padding: const EdgeInsets.all(36.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                             mainAxisAlignment: MainAxisAlignment.start,
                             crossAxisAlignment: CrossAxisAlignment.start,
                                children:<Widget>[

              Text("Register to be invited this Shabbat ${DateFormat('d').format(day)} to a family",
                style : TextStyle(
                  color:Colors.black,
                  fontSize: 25,
                ),

              ),
              SizedBox(height : 20),
              status_religionField,
              SizedBox(height : 20),
              locationField,
              SizedBox(height : 20),
              descriptionField,
              SizedBox(height : 20),
              Submit,

            ]
                            )
                        )

                    )
                )
            ),


      appBar:AppBar(
        title :Text("Families Contact"),
      ),




    );
  }

  postDetailsToFireStore() async {
    //calling our firebase
    // calling our user model;
    // sedding the values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    InvitationUserModel invitationUserModel = InvitationUserModel();
    invitationUserModel.uid =user!.uid;
    invitationUserModel.status_religion=status_religionEditingController.text;
    invitationUserModel.description =descriptionEditingController.text;
    invitationUserModel.location= locationEditingConroller.text;
    if (_formKey.currentState!.validate()) {
      await firebaseFirestore
          .collection("invitation_user")
          .doc(user.uid)
          .set(invitationUserModel.toMap());
      Fluttertoast.showToast(msg: "your request has been sent :)");
      Navigator.pop(context);

    }




  }
  Future<void> logout(BuildContext context) async{
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeScreenGeneral()));
  }
}

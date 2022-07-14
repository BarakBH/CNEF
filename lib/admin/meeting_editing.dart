import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/admin/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class MeetingEditing extends StatefulWidget {
  const MeetingEditing({Key? key}) : super(key: key);

  @override
  _MeetingEditingState createState() => _MeetingEditingState();
}

class _MeetingEditingState extends State<MeetingEditing> {
  @override
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedUser = UserModel();
  final _formKey =GlobalKey<FormState>();
  late DateTime fromDate;
  late DateTime toDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fromDate=DateTime.now();
    toDate = DateTime.now().add(Duration(hours:2));

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
  @override
  Widget build(BuildContext context) {
    List<Widget> buildEditingEditions() =>
        [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: () {}, icon: Icon(Icons.done), label: Text('SAVE'),)
        ];
    Widget buildDropdownField(
        {required String text, required VoidCallback onClicked}) =>
          ListTile(
            title: Text(text),
            trailing: Icon(Icons.arrow_drop_down),
            onTap: onClicked,
          );
    Widget buildHeader({required String header,required Widget child})=>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(header,style: TextStyle(fontWeight: FontWeight.bold),)
      ],
    );

    Widget buildForm()=>
    buildHeader (
        header:'DE',
        child : Row(
      children: [
        Expanded(
          flex: 2,
          child: buildDropdownField(text: Utils.toDate(fromDate),onClicked:(){}),

        ),
        Expanded(child: buildDropdownField(text: Utils.toTime(fromDate),onClicked:(){}),

        ),
      ],
    )
    );
    Widget buildTo()=>
        buildHeader (
            header:'À',
            child : Row(
              children: [
                Expanded(
                  flex: 2,
                  child: buildDropdownField(text: Utils.toDate(toDate),onClicked:(){}),

                ),
                Expanded(child: buildDropdownField(text: Utils.toTime(toDate),onClicked:(){}),

                ),
              ],
            )
        );
    Widget buildDateTimePickers()=>
        Column(
          children: [
            buildForm(),
            buildTo(),
          ],
        );
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(),
        actions:buildEditingEditions(),

      ),
        body:SingleChildScrollView(
          padding: EdgeInsets.all(12),
          child:Form(
            key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              buildDateTimePickers(),
            ],
          ),
          ),
        )
    );








  }
}

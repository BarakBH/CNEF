import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../model/inscription_event.dart';
int check_validate =0;
const webScreenSize = 600;
const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;
class EventCard2 extends StatefulWidget {
  final snap;
  const EventCard2({Key? key,required this.snap}) : super(key: key);

  @override
  _EventCard2State createState() => _EventCard2State();
}

class _EventCard2State extends State<EventCard2> {
  final firstNameEditingController = new TextEditingController();
  final lastNameEditingController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      // boundary needed for web

      padding: const EdgeInsets.symmetric(
        vertical: 7,
      ),
      child: Column(
        children: [
          // HEADER SECTION OF THE POST

          // IMAGE SECTION OF THE POST

          GestureDetector(

            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'].toString(),
                    fit: BoxFit.cover,
                  ),
                ),


              ],
            ),
          ),





        ],
      ),
    );
  }


}


import 'package:cloud_firestore/cloud_firestore.dart';

class OldStudentModel {
  String? uid;
  String? email;
  String? firstname;
  String? lastName;
  String? numberPhone;
  String? description;
  String? domaine;

  OldStudentModel({this.uid,this.email,this.firstname,this.lastName,this.numberPhone,this.domaine,this.description});
  factory OldStudentModel.fromMap(map){
    return OldStudentModel(
      uid: map['uid'],
      email:map['email'],
      firstname: map['firstName'],
      lastName: map['lastName'],
      numberPhone:map['numberPhone'],
      domaine:map['domaine'],
      description:map['description'],



    );
  }

  //dendding data o our server
  Map<String,dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstname,
      'lastName': lastName,
      'numberPhone': numberPhone,
      'domaine': domaine,
      'description': description,


    };
  }
  List<OldStudentModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> map =
      snapshot.data() as Map<String, dynamic>;

      return OldStudentModel(
        uid: map['uid'],
        email:map['email'],
        firstname: map['firstName'],
        lastName: map['lastName'],
        numberPhone:map['numberPhone'],
        domaine:map['domaine'],
        description:map['description'],

      );
    }).toList();
  }
}
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnef_app/model/storage_methos.dart';

class UserModel{
  String? uid;
  String? email;
  String? firstname;
  String? lastName;
  String? gender;
  String? dateBirth;
  String? yearOfAlyah;
  String? status;
  String? id;
  String? numberPhone;
  String? role;
  String? file;

  UserModel({this.uid,this.file,this.email,this.firstname,this.lastName,this.gender,this.dateBirth,this.yearOfAlyah,this.status,this.id,this.numberPhone,this.role});

  //data frm server

  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      file:map['file'],
      email:map['email'],
      firstname: map['firstName'],
      lastName: map['lastname'],
      gender: map['gender'],
      dateBirth: map['dateBirth'],
      yearOfAlyah: map['yearOfAlyah'],
      status: map['status'],
      id: map['id'],
      numberPhone:map['numberPhone'],
      role:map['role'],


    );
  }

  //dendding data o our server
  Map<String,dynamic> toMap(){
    return{
      'uid' : uid,
      'file': file,
      'email' : email,
      'firstName' : firstname,
      'lastname' : lastName,
      'gender' : gender,
      'dateBirth' : dateBirth,
      'yearOfAlyah' : yearOfAlyah,
      'status' : status,
      'id' : id,
      'numberPhone' : numberPhone,
      'role' : role,



    };
  }

  List<UserModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> map =
      snapshot.data() as Map<String, dynamic>;

      return UserModel(
        uid: map['uid'],
        file:map['file'],
        email:map['email'],
        firstname: map['firstName'],
        lastName: map['lastname'],
        gender: map['gender'],
        dateBirth: map['dateBirth'],
        yearOfAlyah: map['yearOfAlyah'],
        status: map['status'],
        id: map['id'],
        numberPhone:map['numberPhone'],
        role:map['role'],


      );
    }).toList();
  }
}





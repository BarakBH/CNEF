

import 'package:cloud_firestore/cloud_firestore.dart';

class RequestUserModel{
  String? description="";
  String? uid;
  String? listFile="" ;
  String? montant="";
  String? firstName="";
  String? lastName="";
  RequestUserModel({this.uid,this.description,this.listFile, this.montant,this.firstName,this.lastName});

  factory RequestUserModel.fromMap(map){
    return RequestUserModel(
      uid: map['uid'],
      description: map['description'],
      listFile:map['file'],
      montant: map['montant'],
      firstName:map['firstName'],
      lastName: map['lastName'],
    );

  }
  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'description': description,
      'file':listFile,
      'montant':montant,
      'firstName':firstName,
      'lastName':lastName,
    };
  }
  List<RequestUserModel> dataListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) {
      final Map<String, dynamic> map =
      snapshot.data() as Map<String, dynamic>;

      return RequestUserModel(
          uid: map['uid'],
          listFile:map['listFile'],
          firstName: map['firstName'],
          lastName: map['lastName'],
          description: map['description'],
          montant: map['montant']

      );
    }).toList();
  }

}
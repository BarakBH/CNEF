
class InscriptionEventModel{

  String? firstName;
  String? lastName;
  String? uid;
  String? title;
  InscriptionEventModel({this.firstName,this.lastName,this.uid, this.title});

  factory InscriptionEventModel.fromMap(map){
    return InscriptionEventModel(
        firstName: map['firstName'],
        lastName: map['lastName'],
        uid:map['uid'],
        title: map['title']
    );

  }
  Map<String,dynamic> toMap() {
    return {
      'firstName' : firstName,
      'lastName': lastName,
      'uid':uid,
      'title':title,

    };
  }
}
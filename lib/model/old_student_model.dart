
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
      lastName: map['lastname'],
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
      'lastname': lastName,
      'numberPhone': numberPhone,
      'domaine': domaine,
      'description': description,


    };
  }
}
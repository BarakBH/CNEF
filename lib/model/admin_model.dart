class AdminModel{
  String? uid;
  String? email;
  String? firstname;
  String? lastName;
  String? gender;
  String? numberPhone;

  AdminModel({this.uid,this.email,this.firstname,this.lastName,this.numberPhone,this.gender});

  factory AdminModel.fromMap(map){
    return AdminModel(
      uid: map['uid'],
      email:map['email'],
      firstname: map['firstName'],
      lastName: map['lastname'],
      gender: map['gender'],
      numberPhone:map[  'numberPhone'],


    );
  }

  //dendding data o our server
  Map<String,dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstname,
      'lastname': lastName,
      'gender': gender,
      'numberPhone': numberPhone,


    };
  }
}
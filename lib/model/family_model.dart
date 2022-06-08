
class FamilyModel{
  String? location;
  String? uid;
  String? lastName;
  String? maxNumberPerson;
  String? numberPhone;
  FamilyModel({this.uid,this.location,this.lastName,this.maxNumberPerson,this.numberPhone});

  factory FamilyModel.fromMap(map){
    return FamilyModel(
      uid: map['uid'],
      location: map['location'],
      lastName: map['lastName'],
      maxNumberPerson: map['maxNumberPerson'],
      numberPhone: map['numberPhone']
    );

  }
  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'location': location,
      'lastName': lastName,
      'maxNumberPerson':maxNumberPerson,
      'numberPhone':numberPhone
    };
  }


}
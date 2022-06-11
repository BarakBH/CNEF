
class FamilyModel{
  String? location;
  String? lastName;
  String? maxNumberPerson;
  String? numberPhone;
  FamilyModel({this.location,this.lastName,this.maxNumberPerson,this.numberPhone});

  factory FamilyModel.fromMap(map){
    return FamilyModel(
      location: map['location'],
      lastName: map['lastName'],
      maxNumberPerson: map['maxNumberPerson'],
      numberPhone: map['numberPhone']
    );

  }
  Map<String,dynamic> toMap() {
    return {
      'location': location,
      'lastName': lastName,
      'maxNumberPerson':maxNumberPerson,
      'numberPhone':numberPhone
    };
  }


}
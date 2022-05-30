class InvitationUserModel{
  String? status_religion="";
  String? description="";
  String? location="";
  String? uid;

  InvitationUserModel({this.uid,this.status_religion,this.description,this.location});

  factory InvitationUserModel.fromMap(map){
    return InvitationUserModel(
      uid: map['uid'],
      status_religion: map['status_religion'],
      description: map['description'],
      location: map['location'],
    );

  }
  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'status_religion': status_religion,
      'description': description,
      'location':location,


    };
  }

}


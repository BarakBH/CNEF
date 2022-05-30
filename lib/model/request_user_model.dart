

class RequestUserModel{
  String? description="";
  String? uid;
  String? listFile="" ;
  String? montant="";
  RequestUserModel({this.uid,this.description,this.listFile, this.montant});

  factory RequestUserModel.fromMap(map){
    return RequestUserModel(
      uid: map['uid'],
      description: map['description'],
      listFile:map['file'],
      montant: map['montant']
    );

  }
  Map<String,dynamic> toMap() {
    return {
      'uid' : uid,
      'description': description,
      'file':listFile,
      'montant':montant,

    };
  }

}
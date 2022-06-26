
class MeetingModel{
  String?title,user,description,id;
  DateTime?  start, end;

  MeetingModel({ this.id, this.title, this.user, this.description, this.start, this.end});

  factory MeetingModel.fromMap(map){
    return MeetingModel(
      title:map['title'],
      user: map['user'],
      start: map['start'],
      end:map['end'],
      description: map['description'],
      id:map['id'],


    );
  }

  //dendding data o our server
  Map<String,dynamic> toMap() {
    return {
      'title': title,
      'user': user,
      'start': start,
      'end': end,
      'description':description,
      'id':id,

    };
  }


}
import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String? title;
  final String? paf;
  final String? uid;
  final String? postId;
  final DateTime? datePublished;
  final String? postUrl;

  Event(
      { this.title,
        this.uid,
        this.postId,
        this.datePublished,
        this.postUrl,
        this.paf,
      });

  static Event fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Event(
      title: snapshot["description"],
      uid: snapshot["uid"],
      postId: snapshot["postId"],
      datePublished: snapshot["datePublished"],
      postUrl: snapshot['postUrl'],
      paf: snapshot['paf'],
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "uid": uid,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
    'PAF': paf,
  };
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? description;
  final String? uid;
  final String? postId;
  final DateTime? datePublished;
  final String? postUrl;

  Post(
      { this.description,
         this.uid,
         this.postId,
         this.datePublished,
         this.postUrl,
      });

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot["description"],
        uid: snapshot["uid"],
        postId: snapshot["postId"],
        datePublished: snapshot["datePublished"],
        postUrl: snapshot['postUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    "description": description,
    "uid": uid,
    "postId": postId,
    "datePublished": datePublished,
    'postUrl': postUrl,
  };
}
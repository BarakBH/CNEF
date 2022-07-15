import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import '../model/event_model.dart';
import '../model/storage_methos.dart';

class FireStoreMethods2 {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadEvent(String title,String moneypaf, Uint8List file, String uid,
      String profImage) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    try {
      String photoUrl =
      await StorageMethods().uploadImageToStorage('events', file, true);
      const uuid = Uuid();
      String postId = uuid.v1(); // creates unique id based on time
      Event event = Event(
        title: title,
        uid: uid,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        paf: moneypaf,
      );
      _firestore.collection('events').doc(postId).set(event.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
  // Delete Post
  Future<String> deleteEvent(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('events').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tutorial/models/brew.dart';
import 'package:firebase_tutorial/models/user.dart';

class DatabaseService {
  final uid;
  DatabaseService({this.uid});
  //Create a collection reference/name
  CollectionReference brewCollection = Firestore.instance.collection('brews');

  Future updateUserData(String name, String sugars, int strength) async {
    return await brewCollection
        .document(uid)
        .setData({'name': name, 'sugars': sugars, 'strength': strength});
  }

  //brew list from snapahot
  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((e) {
      return Brew(
          name: e.data['name'] ?? '',
          strength: e.data['strength'] ?? 100,
          sugars: e.data['sugars'] ?? '0');
    }).toList();
  }

  //user data from snapshot
  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      sugars: snapshot.data['sugars'],
      strength: snapshot.data['strength'],
    );
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData {
    return brewCollection.document(uid).snapshots().map(userDataFromSnapshot);
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorial/models/user.dart';
import 'package:firebase_tutorial/services/database.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //convert firebase user to user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<User> get user {
    return _firebaseAuth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _firebaseAuth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      throw (e);
    }
  }

  //sign up with email & password
  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid: user.uid).updateUserData('Yoshi', '0', 100);
      return _userFromFirebaseUser(user);
    } catch (e) {
      throw (e);
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      throw (e);
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      throw (e);
    }
  }
}

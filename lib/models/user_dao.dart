import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class UserDao extends ChangeNotifier {
  String errorMsg = 'An error has occurred';

  final auth = FirebaseAuth.instance;

  bool isLoggedIn() {
    return auth.currentUser != null;
  }

  String? userId() {
    return auth.currentUser?.uid;
  }

  String? email() {
    return auth.currentUser?.email;
  }

  Future<String?> signup(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(email: email, password: password,);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (error) {
      errorMsg = error.message ?? '';
      return errorMsg;
    } catch (error) {
      log(error.toString());
      return error.toString();
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (error) {
      errorMsg = error.message ?? '';
      return errorMsg;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  void logout() async {
    await auth.signOut();
    notifyListeners();
  }
}
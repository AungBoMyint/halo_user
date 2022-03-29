import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/constant.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> onAuthChange() => _firebaseAuth.authStateChanges();
  Stream<User?> onIdTokenChange() => _firebaseAuth.idTokenChanges();
  Future<IdTokenResult> gettokenResult() =>
      _firebaseAuth.currentUser!.getIdTokenResult(true);

  /////////////
  Future<void> signOutUser() async {
    await _firebaseAuth.signOut();
  }

  Future<void> signIn({required String email, required String password}) async {
    _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then(
          (value) => Get.back(),
          onError: (object) =>
              Get.snackbar("Password is incorrect", "Please Try Again!"),
        );
  }

  Future<void> register(
      {required String email, required String password}) async {
    _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> verifyEmail(
    String email,
    void Function(ApplicationLoginState state) stateCallBack,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        //Sure Partner User
        stateCallBack(ApplicationLoginState.password);
      } else {
        Get.snackbar(
          "Error",
          "Your emil is invalid!.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        stateCallBack(ApplicationLoginState.unauthenticate);
      }
    } on FirebaseAuthException catch (e) {
      debugPrint("********************LoginRegisterError: $e************");
    }
  }

  Future<void> logout() => _firebaseAuth.signOut();
}

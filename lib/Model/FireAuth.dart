import 'package:bwind/Model/AuthResponse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Userbase.dart';

class FireAuth {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future<AuthResponse> registerUserUsingEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    final auth = FireAuth.auth;
    User? user;
    UserCredential? userCredential;
    try {
      userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      await user!.updateDisplayName(name);
      await user.reload();
      user = auth.currentUser;

      Userbase.insertUser(
          Userbase(
                  name: user!.displayName,
                  email: user.email,
                  password: password,
                  createTime: DateTime.now())
              .toMap(),
          user.uid);

      user = userCredential.user;
      return AuthResponse(
          user: user, msg: "Registered Successfully", code: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        return AuthResponse(user: null, msg: "Password is weak !", code: false);
      } else if (e.code == 'email-already-in-use') {
        return AuthResponse(
            user: null, msg: "Email is already registered", code: false);
      }
    } catch (e) {
      print(e);
      return AuthResponse(user: null, msg: "Something Is Wrong", code: false);
    }
    return AuthResponse(user: null, msg: "Something Is Wrong", code: false);
  }

  static Future<AuthResponse> signInUsingEmailPassword(
      {required String email, required String password}) async {
    User? user;
    final auth = FireAuth.auth;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthResponse(user: null, msg: "User Not found", code: false);
      } else if (e.code == 'wrong-password') {
        return AuthResponse(user: null, msg: "Wrong password", code: false);
      }
    }
    return AuthResponse(user: user, msg: "Loged In", code: true);
  }

  static signOut() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      await googleSignIn.signOut();
      await FireAuth.auth.signOut();
      return AuthResponse(user: null, msg: "Loged Out", code: true);
    } catch (e) {
      return AuthResponse(user: null, msg: "Somting is wrong", code: false);
    }
  }

  static Future<AuthResponse> signInUsingGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);
        User? user = userCredential.user;
        Userbase.insertUser(
            Userbase(name: user!.displayName, email: user.email).toMap(),
            user.uid);
        return AuthResponse(user: user, msg: "Login Successfull", code: true);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          return AuthResponse(user: null, msg: "Account exists", code: false);
        } else if (e.code == 'invalid-credential') {
          return AuthResponse(
              user: null, msg: "invalid credential", code: false);
        }
      } catch (e) {
        print(e);
        return AuthResponse(user: null, msg: "Something is wrong", code: false);
      }
    }
    return AuthResponse(
        user: null, msg: "Oops!, process is incomplete", code: false);
  }

  static Future<bool> validateCurrentPassword(String currentPassword) async {
    var auth = FireAuth.auth;
    var user = auth.currentUser;
    var credential = EmailAuthProvider.credential(
        email: user?.email ?? "", password: currentPassword);
    try {
      var reAuthResult = await user!.reauthenticateWithCredential(credential);
      return reAuthResult != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static changePassword(String currentPassword, String newPassword) async {
    if (await validateCurrentPassword(currentPassword)) {
      try {
        final auth = FireAuth.auth;
        var user = auth.currentUser;
        await user?.updatePassword(newPassword);
        await Userbase.changePassword(
            Userbase(
                    name: user!.displayName,
                    email: user.email,
                    password: newPassword,
                    createTime: DateTime.now())
                .toMap(),
            user.uid);
        return AuthResponse(
            user: null, msg: "Password changed successfully", code: true);
      } catch (e) {
        print(e);
        return AuthResponse(
            user: null, msg: "Somthing is wrong! Login again", code: false);
      }
    } else {
      return AuthResponse(
          user: null, msg: "Current password is incorrect", code: false);
    }
  }

  static resetPassword(String newPassword) async {
    try {
      final auth = FireAuth.auth;
      var user = auth.currentUser;
      await user?.updatePassword(newPassword);
      await Userbase.changePassword(
          Userbase(
                  name: user!.displayName,
                  email: user.email,
                  password: newPassword,
                  createTime: DateTime.now())
              .toMap(),
          user.uid);
      return AuthResponse(
          user: null, msg: "Password reset successfully", code: true);
    } catch (e) {
      print(e);
      return AuthResponse(
          user: null, msg: "Somthing is wrong! Try again", code: false);
    }
  }

  static Future<AuthResponse> updateDisplayName(String newName) async {
    User? user;
    try {
      user = auth.currentUser;
      await user!.updateDisplayName(newName);
      return AuthResponse(msg: "updated Successfully", code: true);
    } catch (e) {
      return AuthResponse(msg: "Somthing is wrong! Try again", code: false);
    }
  }
}

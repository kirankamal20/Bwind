 import 'package:distance_edu/Model/AuthResponse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Userbase.dart';

class FireAuth {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static void registerUserUsingEmailPassword({
    required String name,
    required String email,
    required String password,
    required Function() isLoading,
    required Function(String) onError,
    required Function(User) success,
  }) async {
    final auth = FireAuth.auth;

    try {
      isLoading();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      if (userCredential.user != null) {
        userCredential.user!.updateDisplayName(name);
        await userCredential.user!.reload();

        Userbase.insertUser(
            Userbase(
                    name: userCredential.user!.displayName,
                    email: userCredential.user!.email,
                    password: password,
                    createTime: DateTime.now())
                .toMap(),
            userCredential.user!.uid);
        await preferences.setBool("isLogedin", true);
        success(userCredential.user!);
      } else {
        onError("Registration failed");
      }
      // user = userCredential.user;
      // await user!.updateDisplayName(name);
      // await user.reload();
      // user = auth.currentUser;

      // Userbase.insertUser(
      //     Userbase(
      //             name: user!.displayName,
      //             email: user.email,
      //             password: password,
      //             createTime: DateTime.now())
      //         .toMap(),
      //     user.uid);

      // user = userCredential.user;
      // return AuthResponse(
      //     user: user, msg: "Registered Successfully", code: true);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        onError("Password is weak !");
      } else if (e.code == 'email-already-in-use') {
        onError("Email is already registered");
      } else {
        onError("Firebase Auth Error: ${e.code}");
      }
    } catch (e) {
      onError("Error during: ${e.toString()}");
    }
  }

  static void signInUsingEmailPassword(
      {required String email,
      required String password,
      required Function() isLoading,
      required Function(String) onError,
      required Function(User) success}) async {
    final auth = FireAuth.auth;
    try {
      isLoading();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (userCredential.user != null) {
        await preferences.setBool("isLogedin", true);
        success(userCredential.user!);
      } else {
        onError("Sign-in failed: UserCredential is null");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError("User not found. Please enter correct userid.");
      } else if (e.code == 'wrong-password') {
        onError("Password is incorrect.");
      } else {
        onError("Firebase Auth Error: ${e.code}");
      }
    } catch (e) {
      onError("Error during sign-in: ${e.toString()}");
    }
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

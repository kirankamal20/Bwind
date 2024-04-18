import 'package:firebase_auth/firebase_auth.dart';

class FireBaseService {
  static void login(
      {required String email,
      required String password,
      required Function() isLoading,
      required Function(String) onError,
      required Function(UserCredential) success}) async {
    try {
      isLoading();
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      success(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        onError("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        onError("Wrong password provided for that user");
      }
    } catch (e) {
      onError(e.toString());
    }
  }

  static void register(
      {required String email,
      required String password,
      required Function() isLoading,
      required Function(String) onError,
      required Function(UserCredential) success}) async {
    try {
      isLoading();
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      success(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        onError("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        onError("The account already exists for that email.");
      }
    } catch (e) {
      onError(e.toString());
    }
  }
}

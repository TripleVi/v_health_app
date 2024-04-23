import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";

import "shared_pref_service.dart";

class AuthService {
  static final instance = AuthService._();

  AuthService._();

  final _googleSignIn = GoogleSignIn(
    signInOption: SignInOption.standard,
    scopes: [
      "email",
    ], 
  );

  bool isSignedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  Future<GoogleSignInAccount?> getGoogleSignInAccount() async {
    // GoogleAuthProvider
    final isSignedIn = await _googleSignIn.isSignedIn();
    if(isSignedIn) {
      await _googleSignIn.signOut();
    }
    // Trigger the authentication flow
    return _googleSignIn.signIn();
  }

  Future<OAuthCredential> createGoogleAuthCredential() async {
    assert(_googleSignIn.currentUser != null);
    // Obtain the auth details from the request
    final googleAuth = await _googleSignIn.currentUser!.authentication;
    // Create a new credential
    return GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
  }

  void signUpWithGoogle() {
    FirebaseAuth.instance
                        .authStateChanges()
                        .listen((User? user) {
                          if (user == null) {
                            print('User is currently signed out!');
                            
                          } else {
                            print('User is signed in!');
                          }
                        });print("hello world");
  }

  // Future<UserCredential?> signInWithGoogle() async {
  //   final credential = await obtainGoogleAuthCredential();
  //   if(credential == null) {
  //     return null;
  //   }
  //   // Once signed in, return the UserCredential
  //   return await FirebaseAuth.instance.signInWithCredential(credential);
  // }

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) {
    try {
      return FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    try {
      return FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        print('The password provided is too weak.');
      } else if (e.code == "wrong-password") {
        print('The account already exists for that email.');
      } else if (e.code == "user-not-found") {
        print('The account already exists for that email.');
      }
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> linkWithEmailAndPassword(String email, String password) {
    final credential = EmailAuthProvider.credential(email: email, password: password);
    return FirebaseAuth.instance.currentUser!.linkWithCredential(credential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await SharedPrefService.removeCurrentUser();
    await _googleSignIn.signOut();
  }
}

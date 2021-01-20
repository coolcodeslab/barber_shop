import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/utils/App.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:barber_shop/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final GoogleSignIn _googleSignIn = GoogleSignIn();

final _auth = FirebaseAuth.instance;
final _fireStore = FirebaseFirestore.instance;

class Authentication {
  /*Checks the the users email and password and if it has a value
  the screen is pushed to HomeScreen.If the value is equal to null
  Provider logInError variable is set to false(Error text is shown)*/

  void logIn(context, {String email, String password}) async {
    Provider.of<ProviderData>(context, listen: false).showLogInSpinner = true;
    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (user != null) {
        Navigator.pushNamed(context, HomeScreen.id);
        App.prefs.setString("uid", user.user.uid);
      }
    } catch (e) {
      Provider.of<ProviderData>(context, listen: false).loginError = true;
      print(
          'error login ${Provider.of<ProviderData>(context, listen: false).loginError}');
    }
    Provider.of<ProviderData>(context, listen: false).showLogInSpinner = false;
  }

  void singUp(context, {String email, String password, String userName}) async {
    Provider.of<ProviderData>(context, listen: false).showSignUpSpinner = true;
    try {
      final user = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      final uid = _auth.currentUser.uid;
      await _fireStore.collection('users').doc(uid).set({
        'email': email,
        'password': password,
        'uid': uid,
        'userName': userName,
      });
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        App.prefs.setString("uid", uid);
      }
    } catch (e) {
      Provider.of<ProviderData>(context, listen: false).signUpError = true;
      print(
          'error signUp ${Provider.of<ProviderData>(context, listen: false).signUpError}');
    }
    Provider.of<ProviderData>(context, listen: false).showSignUpSpinner = false;
  }

  /*Gets the credentials from apple api and sign into firebase with credentials

 uid, email and userName are taken and set to the specific fields

 Sets the password as logged in with Apple*/
  void signInWithApple(BuildContext context) async {
    try {
      final appleIdCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final oAuthProvider = OAuthProvider('apple.com');
      final credential = oAuthProvider.credential(
        accessToken: appleIdCredential.authorizationCode,
        idToken: appleIdCredential.identityToken,
      );
      print(appleIdCredential);
      print(credential);

      //After this its my code
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      final User user = userCredential.user;

      final User currentUser = _auth.currentUser;

      final uid = _auth.currentUser.uid;
      final userName = _auth.currentUser.displayName;

      await _fireStore.collection('users').doc(uid).set({
        'email': _auth.currentUser.email,
        'password': 'Signed in with Apple',
        'uid': uid,
        'userName': userName,
      });
      print(userName);
      if (currentUser != null) {
        Navigator.pushNamed(context, HomeScreen.id);
        App.prefs.setString("uid", uid);
      }
    } catch (e) {
      print(e);
    }
  }

  /*Gets the credentials from google api and sign into firebase with credentials

 uid, email , userName are taken and set to the specific fields

 Sets the password as logged in with Google*/
  Future<String> googleSignIn(BuildContext context) async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(authCredential);
      final User user = userCredential.user;
      assert(user.displayName != null);
      assert(user.email != null);

      final User currentUser = _auth.currentUser;

      final uid = _auth.currentUser.uid;
      final userName = _auth.currentUser.displayName;

      await _fireStore.collection('users').doc(uid).set({
        'email': _auth.currentUser.email,
        'password': 'Signed in with google',
        'uid': uid,
        'userName': userName,
      });



      if (currentUser != null) {
        Navigator.pushNamed(context, HomeScreen.id);
        App.prefs.setString("uid", uid);
      }

      assert(currentUser.uid == user.uid);

      print(_auth.currentUser.uid);
      print(_auth.currentUser.email);
    } catch (e) {
      print(e);
    }

    return 'Error occurred';
  }

  void resetPassword({String email}) async {
    print('resetting password');
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
    print('done');
  }
}

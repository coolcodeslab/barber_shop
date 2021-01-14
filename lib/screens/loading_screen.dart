import 'dart:io';
import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/screens/home_screen.dart';
import 'package:barber_shop/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatefulWidget {
  static const id = 'loading screen';
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    checkPlatform();
    assignUser();
  }

  String uid;

  void checkPlatform() {
    /*Check is platform is android and if it is so it sets the isAndroid
    Provider variable to true*/
    if (Platform.isAndroid) {
      Provider.of<ProviderData>(context, listen: false).isAndroid = true;
    } else {
      Provider.of<ProviderData>(context, listen: false).isAndroid = false;
    }
  }

  /*Gets the current users uid when app is opened and assigns it to uid var
  If user has logged out the value will be equal to null*/
  void assignUser() async {
    try {
      uid = _auth.currentUser.uid;
      print("success");
    } catch (e) {
      print("its a null");
      uid = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    /*Checks if uid has a value and if there is then screen is pushed to
    home screen.If uid == null Screen is Pushed to Login screen*/
    return uid == null ? LoginScreen() : HomeScreen();
  }
}

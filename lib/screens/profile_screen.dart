import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  static const id = 'profile screen';
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  String uid;
  @override
  void initState() {
    uid = _auth.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fireStore.collection('users').doc(uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Theme(
                data: ThemeData(accentColor: kButtonColor),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final data = snapshot.data;
          final String email = data['email'];
          final String uid = data['uid'];
          final String userName = data['userName'];

          print(data);
          print(email);

          //Profile Card
          return ProfileCard(
            email: email,
            uid: uid,
            userName: userName,
          );
        });
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    @required this.email,
    this.uid,
    this.userName,
  });

  final String email;
  final String uid;
  final String userName;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            height: height * 0.45,
            width: width * 0.533,
            decoration: BoxDecoration(
              color: kPopUpContainerColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //User image
                Center(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: height * 0.15,
                        width: width * 0.267,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            image: DecorationImage(
                              image: NetworkImage(kUserImage),
                            )))),
                //User name
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      userName,
                      style: kServicesTextStyle.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.015,
                ),

                //User email
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    email,
                    style: kServicesTextStyle.copyWith(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ),

                //User Id
                Padding(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Text(
                    'uid: $uid',
                    style: kServicesTextStyle.copyWith(
                      fontSize: 7,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/screens/edit_profile_screen.dart';
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

          String imageUrl;
          try {
            imageUrl = data['imageUrl'];
          } catch (e) {
            imageUrl = kUserImage;
          }

          String mobileNumber;
          try {
            mobileNumber = data['mobileNumber'];
          } catch (e) {
            mobileNumber = null;
          }

          print(data);
          print(email);

          //Profile Card
          return ProfileCard(
            email: email,
            mobileNumber: mobileNumber,
            userName: userName,
            imageUrl: imageUrl,
          );
        });
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    @required this.email,
    this.userName,
    this.imageUrl,
    this.mobileNumber,
  });

  final String email;

  final String userName;
  final String imageUrl;
  final String mobileNumber;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        height: height * 0.45,
        width: width * 0.533,
        decoration: BoxDecoration(
          color: Colors.white,
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
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: imageUrl,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ))),
            //User name
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Text(
                  userName,
                  style: kServicesTextStyle.copyWith(
                    fontSize: 15,
                    color: Colors.black,
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
                  color: Colors.black,
                ),
              ),
            ),

            //User Id
            mobileNumber == null
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Text(
                      'mobile No: $mobileNumber',
                      style: kServicesTextStyle.copyWith(
                        fontSize: 7,
                        color: Colors.black,
                      ),
                    ),
                  ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: RoundButtonWidget(
                title: 'edit',
                width: 100,
                height: 30,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProfileScreen(
                                userName: userName,
                                mobileNumber: mobileNumber,
                                imageUrl: imageUrl,
                              )));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

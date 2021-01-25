import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/screens/order_summary.dart';
import 'package:barber_shop/utils/App.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddressBook extends StatefulWidget {
  AddressBook({Key key}) : super(key: key);

  @override
  _AddressBookState createState() => _AddressBookState();
}

class _AddressBookState extends State<AddressBook> {
  final _auth = FirebaseAuth.instance;
  TextEditingController _textEditingController = TextEditingController();

  Map userData = Map();
  bool isLoading = false;
  String uid;
  bool error = false;

  @override
  void initState() {
    uid = _auth.currentUser.uid;
    super.initState();
    fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    print(App.prefs.getString("uid"));
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ListView(
        children: [
          //Back button
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BackButton(
                  color: kButtonColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Address",
              style: kHeadingTextStyle,
            ),
          ),
          TextFieldWidget(
            controller: _textEditingController,
            maxLines: 6,
            maxLength: 150,
            errorText: error ? 'please enter an address' : null,
          ),
          Align(
            alignment: Alignment.center,
            child: RoundButtonWidget(
              title: 'Order Summary',
              onTap: () {
                setAddress();
              },
            ),
          ),
        ],
      ),
    );
  }

  setAddress() {
    if (mounted) {
      setState(() {
        isLoading = true;
        error = false;
      });
    }
    if (_textEditingController.text == userData['address']) {
      // Address is Same as Before
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderSummary(
            payLoad: {"address": _textEditingController.text},
          ),
        ),
      );
    } else if (_textEditingController.text.isEmpty) {
      if (mounted) {
        setState(() {
          isLoading = false;
          error = true;
        });
      }
      return;
    } else {
      try {
        FirebaseFirestore.instance
            .collection("users")
            .doc(App.prefs.getString("uid"))
            .update({
          "address": _textEditingController.text,
        }).then((value) {
          // Push To Order Summary
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderSummary(
                payLoad: {"address": _textEditingController.text},
              ),
            ),
          );
        });
      } catch (err) {
        print("Error on Settinf Address ==> $err");
        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
    }
  }

  Future fetchAddress() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .get()
          .then((value) {
        if (mounted)
          setState(() {
            userData = value.data();
            isLoading = false;
            _textEditingController.text = value.data()['address'] ?? "";
          });
      });
    } catch (err) {
      print("Error on Fetching Address ==> $err");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

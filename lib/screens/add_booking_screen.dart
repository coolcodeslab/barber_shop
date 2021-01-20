import 'dart:ui';
import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/screens/home_screen.dart';
import 'package:barber_shop/screens/pick_a_time_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';

class AddBookingScreen extends StatefulWidget {
  static const id = 'booking screen';
  AddBookingScreen({this.serviceName});
  final String serviceName;

  @override
  _AddBookingScreenState createState() => _AddBookingScreenState();
}

class _AddBookingScreenState extends State<AddBookingScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();

  String name;
  String mobileNo;
  bool showSpinner = false;
  bool error = false;
  Map<String, dynamic> mapResponseFromPickATimeScreen;

  /*Starting name for the dropdown menu should be the name of an the item in
  the list, if not the app will crash */
  String serviceName = kDropDownFirstValue;

  @override
  void initState() {
    serviceName = widget.serviceName;
    Provider.of<ProviderData>(context, listen: false).isTimePicked = false;
    print(Provider.of<ProviderData>(context, listen: false).isTimePicked);
    super.initState();
  }

  void onChangedName(n) {
    name = n;
    setState(() {
      error = false;
    });
  }

  void onChangedMobileNo(n) {
    mobileNo = n;
    setState(() {
      error = false;
    });
  }

  /*A booking is saved in the current users booking collection and in common
  booking collection which will be displayed in the admin bookings screen

  Name, service, time, mobile no, uid and time stamp of the date booked in
  (2 January 2021) format will be saved inside bookings
  collections

  A random booking Id is generated using randomAlphaNumeric package

  Checks if name == null , Mobile no == null and pick a time == null

  The screen pops to Home Screen when the booking is success*/
  void onTapBookNow() async {
    setState(() {
      showSpinner = true;
      nameController.clear();
      mobileNoController.clear();
    });
    if (name == null ||
        mobileNo == null ||
        Provider.of<ProviderData>(context, listen: false).isTimePicked ==
            false) {
      setState(() {
        error = true;
        showSpinner = false;
      });
      return;
    } else {
      final String bookingId = randomAlphaNumeric(9);
      final String uid = _auth.currentUser.uid;

      //Saves booking inside user collection
      await _fireStore
          .collection('users')
          .doc(uid)
          .collection('bookings')
          .doc(bookingId)
          .set(
        {
          'name': name,
          'service': serviceName,
          'time': mapResponseFromPickATimeScreen['time'],
          'mobileNo': mobileNo,
          'uid': uid,
          'timeStamp': mapResponseFromPickATimeScreen['dateTime'],
          'bookingId': bookingId,
          'isBooked': true,
          'index': mapResponseFromPickATimeScreen['index'],
        },
      );

      //Adds time Stamp to the field inside the date document
      await _fireStore
          .collection('bookingDates')
          .doc(
              '${mapResponseFromPickATimeScreen['date']}-${mapResponseFromPickATimeScreen['month']}-${mapResponseFromPickATimeScreen['year']}')
          .set({
        'timeStamp': mapResponseFromPickATimeScreen['dateTime'],
      });

      //Saves booking inside booking dates collection
      await _fireStore
          .collection('bookingDates')
          .doc(
              '${mapResponseFromPickATimeScreen['date']}-${mapResponseFromPickATimeScreen['month']}-${mapResponseFromPickATimeScreen['year']}')
          .collection('time')
          .doc('${mapResponseFromPickATimeScreen['index']}')
          .set({
        'name': name,
        'service': serviceName,
        'mobileNo': mobileNo,
        'uid': uid,
        'timeStamp': mapResponseFromPickATimeScreen['dateTime'],
        'bookingId': bookingId,
        'isBooked': true,
        'time': '${mapResponseFromPickATimeScreen['time']}',
        'index': mapResponseFromPickATimeScreen['index'],
        'isCompleted': false,
      });

      Navigator.pushNamed(context, HomeScreen.id);
    }
    setState(() {
      showSpinner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: Theme(
        data: ThemeData(accentColor: kButtonColor),
        child: CircularProgressIndicator(),
      ),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              //BackGround design
              BackGroundDesign(
                height: height * 0.45,
                width: width * 1.333,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 0.045,
                  ),

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

                  //Add Booking Heading
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                    ),
                    child: Text(
                      'Add Booking',
                      style: kHeadingTextStyle,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.045,
                  ),

                  //Name field
                  TextFieldWidget(
                    hintText: 'name',
                    onChanged: onChangedName,
                    errorText: error ? 'please enter a value' : null,
                    controller: nameController,
                  ),

                  //Mobile no field
                  TextFieldWidget(
                    hintText: 'mobile no',
                    onChanged: onChangedMobileNo,
                    controller: mobileNoController,
                    errorText: error ? 'please enter a value' : null,
                  ),

                  //Pick a time button
                  PickATimeButton(
                    onTap: () async {
                      mapResponseFromPickATimeScreen = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PickATimeScreen(),
                        ),
                      );
                    },
                    isTimePicked:
                        Provider.of<ProviderData>(context, listen: false)
                            .isTimePicked,
                  ),

                  //Dropdown Services
                  FutureBuilder(
                      future: _fireStore.collection('services').get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: Container(),
                          );
                        }
                        List<String> serviceList = [];
                        for (var eachService in snapshot.data.docs) {
                          final serviceName = eachService['name'];
                          serviceList.add(serviceName);
                        }

                        //This is a custom Dropdown widget
                        return DropDownWidget(
                          serviceList: serviceList,
                          onChanged: (n) {
                            setState(() {
                              serviceName = n;
                            });
                          },
                          serviceName: serviceName,
                        );
                      }),
                  SizedBox(
                    height: height * 0.075,
                  ),

                  //Book now button
                  Center(
                    child: RoundButtonWidget(
                      title: 'book now',
                      onTap: onTapBookNow,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PickATimeButton extends StatelessWidget {
  PickATimeButton({this.onTap, this.isTimePicked});
  final Function onTap;
  final bool isTimePicked;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(left: 20, right: 20, top: 15),
        margin: EdgeInsets.only(
          bottom: 20,
          left: 30,
          right: 30,
        ),
        height: height * 0.067,
        width: width,
        child: Text(
          'pick a time',
          style: TextStyle(
            color: isTimePicked ? Colors.white : Colors.red,
          ),
        ),
      ),
    );
  }
}

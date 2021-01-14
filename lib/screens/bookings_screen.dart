import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentsScreen extends StatefulWidget {
  static const id = 'appointments screen';
  AppointmentsScreen({this.uid});
  final String uid;
  @override
  _AppointmentsScreenState createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends State<AppointmentsScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  String uid;
  String email;
  DateTime dateTimeNow;
  DateTime dateToday;
  String dayToday;

  /*Initially UID is == null

  When the state is build uid is assign to current users UID*/

  @override
  void initState() {
    dateTimeNow = DateTime.now();
    dateToday = DateTime(dateTimeNow.day, dateTimeNow.month, dateTimeNow.year);
    dayToday = DateFormat('EEEE').format(dateTimeNow);
    uid = _auth.currentUser.uid;
    super.initState();
  }

  void onTapBookingCancel(
      {String date, String uid, String bookingId, String index}) async {
    try {
      await _fireStore
          .collection('bookingDates')
          .doc(date)
          .collection('time')
          .doc(index)
          .delete();
      await _fireStore
          .collection('users')
          .doc(uid)
          .collection('bookings')
          .doc(bookingId)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          BackGroundDesign(
            height: height * 0.75,
            width: width * 1.333,
          ),
          ListView(
            children: [
              SizedBox(
                height: height * 0.015,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    BackButton(
                      color: kButtonColor,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: Text(
                  'Bookings',
                  style: kHeadingTextStyle,
                ),
              ),
              SizedBox(
                height: height * 0.03,
              ),

              /*All the bookings in the currents users booking collections
              is displayed

              Only name of the name given when booking is displayed*/
              StreamBuilder<QuerySnapshot>(
                stream: _fireStore
                    .collection('users')
                    .doc(uid)
                    .collection('bookings')
                    .where('timeStamp', isGreaterThanOrEqualTo: dateToday)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: Theme(
                          data: ThemeData(accentColor: kButtonColor),
                          child: CircularProgressIndicator()),
                    );
                  }

                  final List<Widget> bookingList = [];

                  final bookings = snapshot.data.docs;

                  for (var eachBooking in bookings) {
                    final name = eachBooking['name'];
                    final timeStamp = eachBooking['timeStamp'];
                    final service = eachBooking['service'];
                    final time = eachBooking['time'];
                    final bookingId = eachBooking['bookingId'];

                    var date = timeStamp.toDate();
                    String day = DateFormat('EEEE').format(date);
                    String dayNum = DateFormat('d').format(date);
                    String monthNum = DateFormat('M').format(date);
                    String yearNum = DateFormat('y').format(date);

                    String dateDocString = '$dayNum-$monthNum-$yearNum';
                    final containerIndex = eachBooking['index'].toString();
                    final uid = eachBooking['uid'];

                    if (day == dayToday) {
                      day = 'Today';
                    }

                    final bookingCard = BookingCard(
                      name: name,
                      service: service,
                      time: time,
                      day: day,
                      bookingId: bookingId,
                      onTapCancel: () {
                        onTapBookingCancel(
                          date: dateDocString,
                          index: containerIndex,
                          uid: uid,
                          bookingId: bookingId,
                        );
                      },
                    );

                    bookingList.add(bookingCard);
                  }

                  return Column(
                    children: bookingList,
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

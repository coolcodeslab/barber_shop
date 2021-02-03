import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/provider_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BookingsScreen extends StatefulWidget {
  static const id = 'appointments screen';
  BookingsScreen({this.uid});
  final String uid;
  @override
  _BookingsScreenState createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
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
    dateToday = DateTime(dateTimeNow.year, dateTimeNow.month, dateTimeNow.day);
    dayToday = DateFormat('EEEE').format(dateTimeNow);
    uid = _auth.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kButtonColor,
        ),
        title: Text(
          'Bookings',
          style: kHeadingTextStyle,
        ),
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: height * 0.015,
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
                    ///name
                    final name = eachBooking['name'];

                    ///timeStamp
                    final timeStamp = eachBooking['timeStamp'];

                    ///service name
                    final service = eachBooking['service'];

                    ///time
                    final time = eachBooking['time'];

                    ///bookingIf
                    final bookingId = eachBooking['bookingId'];

                    ///Date only string
                    var date = timeStamp.toDate();
                    String day = DateFormat('EEEE').format(date);
                    String dayNum = DateFormat('d').format(date);
                    String monthNum = DateFormat('M').format(date);
                    String yearNum = DateFormat('y').format(date);
                    String dateDocString = '$dayNum-$monthNum-$yearNum';

                    final containerIndex = eachBooking['index'].toString();

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

  void cancelBooking({String date, String index, String bookingId}) async {
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
    print('hey the booking slot at 5.30pm on 12/6 is free');
  }

  void onTapBookingCancel({String date, String bookingId, String index}) async {
    final bool isAndroid =
        Provider.of<ProviderData>(context, listen: false).isAndroid;

    //confirmation dialog box
    showDialog(
      context: context,
      builder: (BuildContext context) => isAndroid
          ? AlertDialog(
              title: Text("Cancel booking"),
              content: Text("Are you sure you want to cancel Booking?"),
              actions: [
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                FlatButton(
                  child: Text("Continue"),
                  onPressed: () {
                    Navigator.pop(context);
                    cancelBooking(
                        date: date, bookingId: bookingId, index: index);
                  },
                ),
              ],
            )
          : CupertinoAlertDialog(
              title: Text("Cancel booking"),
              content: Text("Are you sure you want to cancel Booking?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.pop(context);
                    cancelBooking(
                        date: date, bookingId: bookingId, index: index);
                  },
                ),
                CupertinoDialogAction(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
    );
  }
}

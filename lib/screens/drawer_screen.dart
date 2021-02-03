import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/screens/bookings_screen.dart';
import 'package:barber_shop/screens/login_screen.dart';
import 'package:barber_shop/screens/order_history_screen.dart';
import 'package:barber_shop/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({this.width});

  final double width;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.36,
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: height * 0.045,
          ),

          //Profile
          DrawerItem(
            widget: widget,
            onTap: onTapProfile,
            name: 'Profile',
          ),

          //Booking
          DrawerItem(
            widget: widget,
            onTap: onTapBooking,
            name: 'Booking',
          ),

          //Order history
          DrawerItem(
            widget: widget,
            name: 'Order history',
            onTap: onTapOrderHistory,
          ),

          //Log out
          DrawerItem(
            widget: widget,
            name: 'Log out',
            onTap: onTapLogOut,
          ),
        ],
      ),
    );
  }

  //pushes to profile screen
  void onTapProfile() {
    Navigator.pop(context);
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: ProfileScreen(),
        );
      },
    );
//    Navigator.pushNamed(context, ProfileScreen.id);
  }

  //Pushes to the appointments screen
  void onTapBooking() {
    Navigator.pop(context);
    Navigator.pushNamed(context, BookingsScreen.id);
  }

  //Signs out User and pushes the screen to LoginScreen
  void onTapLogOut() {
    final bool isAndroid =
        Provider.of<ProviderData>(context, listen: false).isAndroid;
    //confirmation dialog box
    showDialog(
      context: context,
      builder: (BuildContext context) => isAndroid
          ? AlertDialog(
              title: Text("Log Out"),
              content: Text("Are you sure you want to log out?"),
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
                    _auth.signOut();
                    Navigator.pushNamed(context, LoginScreen.id);
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          : CupertinoAlertDialog(
              title: new Text("Log Out"),
              content: new Text("Are you sure you want to log out?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text("Yes"),
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pushNamed(context, LoginScreen.id);
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

  void onTapOrderHistory() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OrderHistoryScreen()));
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({@required this.widget, this.onTap, this.name});

  final CustomDrawer widget;
  final Function onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widget.width,
        height: height * 0.075,
        child: Center(
          child: Text(
            name,
            style: TextStyle(color: Colors.black),
          ),
        ),
        color: Colors.white,
//          0xff4D4A56
      ),
    );
  }
}

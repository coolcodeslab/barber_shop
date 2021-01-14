import 'package:barber_shop/screens/bookings_screen.dart';
import 'package:barber_shop/screens/login_screen.dart';
import 'package:barber_shop/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatefulWidget {
  CustomDrawer({this.width});
  final double width;

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final _auth = FirebaseAuth.instance;

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
    Navigator.pushNamed(context, AppointmentsScreen.id);
  }

  //Signs out User and pushes the screen to LoginScreen
  void onTapLogOut() {
    _auth.signOut();
    Navigator.pushNamed(context, LoginScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      width: width * 0.36,
      color: Color(0xff4D4A56),
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
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({@required this.widget, this.onTap, this.name});

  final CustomDrawer widget;
  final Function onTap;
  final String name;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: widget.width,
        height: height * 0.075,
        child: Center(
          child: Text(
            name,
            style: TextStyle(color: Colors.white),
          ),
        ),
        color: Color(0xff4D4A56),
      ),
    );
  }
}

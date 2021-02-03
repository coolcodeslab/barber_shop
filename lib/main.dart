import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/screens/bookings_screen.dart';
import 'package:barber_shop/screens/order_history_screen.dart';
import 'package:barber_shop/screens/pick_a_time_screen.dart';
import 'package:barber_shop/screens/add_booking_screen.dart';
import 'package:barber_shop/screens/home_screen.dart';
import 'package:barber_shop/screens/item_screen.dart';
import 'package:barber_shop/screens/loading_screen.dart';
import 'package:barber_shop/screens/login_screen.dart';
import 'package:barber_shop/screens/profile_screen.dart';
import 'package:barber_shop/screens/reset_password_screen.dart';
import 'package:barber_shop/screens/signup_screen.dart';
import 'package:barber_shop/screens/term_and_service_screen.dart';
import 'package:barber_shop/utils/App.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  App.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProviderData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: LoadingScreen.id,
        theme: ThemeData(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
        ),
        routes: {
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          AddBookingScreen.id: (context) => AddBookingScreen(),
          BookingsScreen.id: (context) => BookingsScreen(),
          ItemScreen.id: (context) => ItemScreen(),
          LoadingScreen.id: (context) => LoadingScreen(),
          PickATimeScreen.id: (context) => PickATimeScreen(),
          ProfileScreen.id: (context) => ProfileScreen(),
          ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
          TermsAndServicesScreen.id: (context) => TermsAndServicesScreen(),
          OrderHistoryScreen.id: (context) => OrderHistoryScreen(),
        },
      ),
    );
  }
}

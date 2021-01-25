import 'package:barber_shop/auth_service.dart';
import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/provider_data.dart';
import 'package:flutter/material.dart';
import 'package:barber_shop/terms_and_services.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class TermsAndServicesScreen extends StatefulWidget {
  static const id = 'terms and services screen';
  TermsAndServicesScreen({this.email, this.password, this.userName});

  final String email;
  final String password;
  final String userName;

  @override
  _TermsAndServicesScreenState createState() => _TermsAndServicesScreenState();
}

class _TermsAndServicesScreenState extends State<TermsAndServicesScreen> {
  Authentication authentication = Authentication();

  @override
  void initState() {
    /*When TermsAndServicesScreen is built it sets the signUpError and showSignUpSpinner
     Provider variables to false

     This way the errorText and loading spinner is not shown*/

    Provider.of<ProviderData>(context, listen: false).showSignUpSpinner = false;
    super.initState();
  }

  void onTapSignUp() {
    authentication.singUp(
      context,
      email: widget.email,
      password: widget.password,
      userName: widget.userName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ProviderData>(context).showSignUpSpinner,
        progressIndicator: Theme(
          data: ThemeData(accentColor: kButtonColor),
          child: CircularProgressIndicator(),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: height * 0.045,
                width: double.infinity,
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
              //Change Logo Here
              Hero(
                tag: 'logo',
                child: Container(
                  height: height * 0.15,
                  width: width * 0.27,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/logo.png'),
                    ),
                  ),
                ),
              ),

              Container(
                height: height * 0.525,
                width: width * 0.8,
                color: kBackgroundColor,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    Text(
                      kTermsAndServices,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
              ),
              SizedBox(
                height: height * 0.03,
              ),
              RoundButtonWidget(
                title: 'Sign up',
                onTap: onTapSignUp,
              ),
              //Login Button
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/screens/home_screen.dart';
import 'package:barber_shop/screens/reset_password_screen.dart';
import 'package:barber_shop/screens/signup_screen.dart';
import 'package:barber_shop/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber_shop/barber_widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Authentication authentication = Authentication();

  final _auth = FirebaseAuth.instance;

  String email;
  String password;
  bool passedVar;
  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    Provider.of<ProviderData>(context, listen: false).loginError = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;

    final isAndroid = Provider.of<ProviderData>(context).isAndroid;
    return WillPopScope(
      onWillPop: () async => false,
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: Theme(
          data: ThemeData(accentColor: kButtonColor),
          child: CircularProgressIndicator(),
        ),
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height * 0.045,
                ),

                ///Logo
                Hero(
                  tag: 'logo',
                  child: Container(
                    height: height * 0.27,
                    width: width * 0.48,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('images/PLUCK CUTZ.png'),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: height * 0.03,
                ),

                ///Email field
                TextFieldWidget(
                  hintText: 'Email',
                  onChanged: onChangeEmail,
                  errorText: Provider.of<ProviderData>(context).loginError
                      ? kLogInErrorText
                      : null,
                  controller: emailController,
                ),

                ///Password field
                TextFieldWidget(
                  hintText: 'Password',
                  onChanged: onChangedPassword,
                  obscureText: true,
                  controller: passwordController,
                  maxLines: 1,
                ),

                ///Forgot password button
                Align(
                  alignment: Alignment.centerLeft,
                  child: ForgotPasswordButton(
                    onTap: onTapForgotPasswordButton,
                  ),
                ),

                ///Login Button
                RoundButtonWidget(
                  title: 'login',
                  onTap: onTapLogin,
                ),

                ///Signup Button
                RoundButtonWidget(
                  title: 'sign up',
                  onTap: onTapSignup,
                ),

                ///Check platform before showing buttons

                ///Google Sign in Button
                isAndroid
                    ? SocialSignInButton(
                        onPressed: onTapGoogleSignIn,
                        buttons: Buttons.Google,
                        color: Colors.white,
                      )

                    ///Apple Sign in Button
                    : SocialSignInButton(
                        onPressed: onTapAppleSignIn,
                        buttons: Buttons.AppleDark,
                        color: Colors.black,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ///When email field is changes
  void onChangeEmail(n) {
    email = n;

    setState(() {
      Provider.of<ProviderData>(context, listen: false).loginError = false;
    });
  }

  ///When password is changes
  void onChangedPassword(n) {
    password = n;
  }

  ///When sign in button is tapped it pushes to the next screen
  void onTapSignup() {
    Navigator.pushNamed(context, SignupScreen.id);
  }

  ///Spinner is only shown for login
  void onTapLogin() async {
    setState(() {
      showSpinner = true;
    });

    try {
      final user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      if (user != null) {
        Navigator.pushNamed(context, HomeScreen.id);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      showSpinner = false;
    });

    emailController.clear();
    passwordController.clear();
  }

  /*When google sign in button is pressed it runs the signIn method in
  authentication class*/
  void onTapGoogleSignIn() async {
    authentication.googleSignIn(context);
  }

  ///When apple sign in button is pressed it runs the signIn method in
  /// authentication class
  void onTapAppleSignIn() {
    authentication.signInWithApple(context);
  }

  ///Pushes to reset password screen
  void onTapForgotPasswordButton() {
    Navigator.pushNamed(context, ResetPasswordScreen.id);
  }
}

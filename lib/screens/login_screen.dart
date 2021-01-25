import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/screens/reset_password_screen.dart';
import 'package:barber_shop/screens/signup_screen.dart';
import 'package:barber_shop/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:barber_shop/barber_widgets.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Authentication authentication = Authentication();

  String email;
  String password;
  bool passedVar;
  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    /*When login screen is built it sets the loginError and showLogInSpinner
     Provider variables to false

     This way the errorText and loading spinner is not shown*/
    Provider.of<ProviderData>(context, listen: false).loginError = false;
    Provider.of<ProviderData>(context, listen: false).showLogInSpinner = false;
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
        inAsyncCall: Provider.of<ProviderData>(context).showLogInSpinner,
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

                //Change Logo Here
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

                //Email field
                TextFieldWidget(
                  hintText: 'Email',
                  onChanged: onChangeEmail,
                  errorText: Provider.of<ProviderData>(context).loginError
                      ? kLogInErrorText
                      : null,
                  controller: emailController,
                ),

                //Password field
                TextFieldWidget(
                  hintText: 'Password',
                  onChanged: onChangedPassword,
                  obscureText: true,
                  controller: passwordController,
                  maxLines: 1,
                ),

                //Forgot password button
                Align(
                  alignment: Alignment.centerLeft,
                  child: ForgotPasswordButton(
                    onTap: onTapForgotPasswordButton,
                  ),
                ),

                //Login Button
                RoundButtonWidget(
                  title: 'login',
                  onTap: onTapLogin,
                ),

                //Signup Button
                RoundButtonWidget(
                  title: 'sign up',
                  onTap: onTapSignup,
                ),

                //Check platform before showing buttons
                isAndroid
                    ? //Google Sign in Button
                    SocialSignInButton(
                        onPressed: onTapGoogleSignIn,
                        buttons: Buttons.Google,
                        color: Colors.white,
                      )
                    //Apple Sign in Button
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

  //When email field is changes
  void onChangeEmail(n) {
    email = n;

    setState(() {
      Provider.of<ProviderData>(context, listen: false).loginError = false;
    });
  }

  //When password is changes
  void onChangedPassword(n) {
    password = n;
  }

  //When sign in button is tapped it pushes to the next screen
  void onTapSignup() {
    Navigator.pushNamed(context, SignupScreen.id);
  }

  /*When login button is pressed it runs the login method in authentication
  class*/
  void onTapLogin() async {
    setState(() {
      Provider.of<ProviderData>(context, listen: false).showLogInSpinner = true;
    });
    authentication.logIn(context, email: email, password: password);
    print('done');

    //Clears the textFields
    setState(() {
      Provider.of<ProviderData>(context, listen: false).showLogInSpinner =
          false;

      emailController.clear();
      passwordController.clear();
    });
  }

  /*When google sign in button is pressed it runs the signIn method in
  authentication class*/
  void onTapGoogleSignIn() {
    authentication.googleSignIn(context);
  }

  /*When apple sign in button is pressed it runs the signIn method in
  authentication class*/
  void onTapAppleSignIn() {
    authentication.signInWithApple(context);
  }

  //Pushes to reset password screen
  void onTapForgotPasswordButton() {
    Navigator.pushNamed(context, ResetPasswordScreen.id);
  }
}

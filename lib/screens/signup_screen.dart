import 'package:barber_shop/auth_service.dart';
import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/screens/term_and_service_screen.dart';
import 'package:flutter/material.dart';
import 'package:barber_shop/barber_widgets.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static const id = 'Signup screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Authentication authentication = Authentication();

  String email;
  String password;
  String userName;
  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  @override
  void initState() {
    /*When SignUp screen is built it sets the signUpError and showSignUpSpinner
     Provider variables to false

     This way the errorText and loading spinner is not shown*/

    Provider.of<ProviderData>(context, listen: false).signUpError = false;
    Provider.of<ProviderData>(context, listen: false).showSignUpSpinner = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;

    final isAndroid = Provider.of<ProviderData>(context).isAndroid;

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
            children: [
              SizedBox(
                height: height * 0.03,
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

              //Logo
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
                height: height * 0.007,
              ),

              //Email field
              TextFieldWidget(
                hintText: 'email',
                onChanged: onChangedEmail,
                controller: emailController,
                errorText: Provider.of<ProviderData>(context).signUpError
                    ? kSignUpErrorText
                    : null,
              ),

              //UserName field
              TextFieldWidget(
                hintText: 'user name',
                onChanged: onChangedUserName,
                controller: userNameController,
              ),

              //Password field
              TextFieldWidget(
                hintText: 'password',
                onChanged: onChangedPassword,
                obscureText: true,
                controller: passwordController,
                maxLines: 1,
              ),

              //Sign up Button
              RoundButtonWidget(
                title: 'sign up',
                onTap: onTapSignup,
              ),

              isAndroid
                  ?
                  //Google Sign in Button
                  SocialSignInButton(
                      onPressed: onTapGoogleSignIn,
                      buttons: Buttons.Google,
                      color: Colors.white,
                    )
                  :
                  //Apple Sign in Button
                  SocialSignInButton(
                      onPressed: onTapAppleSignIn,
                      buttons: Buttons.AppleDark,
                      color: Colors.black,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void onChangedEmail(n) {
    email = n;
    setState(() {
      Provider.of<ProviderData>(context, listen: false).signUpError = false;
    });
  }

  void onChangedPassword(n) {
    password = n;
  }

  void onChangedUserName(n) {
    userName = n;
  }

  /*If email and password are != null user  email, password and
  uid is saved fireStore user collection
  And screen is pushed to home screen*/

  void onTapSignup() {
    if (emailController.text.isEmpty ||
        userNameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      setState(() {
        Provider.of<ProviderData>(context, listen: false).signUpError = true;
      });
      print('empty');
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TermsAndServicesScreen(
                  email: emailController.text,
                  password: passwordController.text,
                  userName: userNameController.text)));
    }
  }

  void onTapGoogleSignIn() {
    setState(() {
      showSpinner = true;
    });

    authentication.googleSignIn(context);

    setState(() {
      showSpinner = false;
    });
  }

  void onTapAppleSignIn() {
    setState(() {
      showSpinner = true;
    });

    authentication.signInWithApple(context);

    setState(() {
      showSpinner = false;
    });
  }
}

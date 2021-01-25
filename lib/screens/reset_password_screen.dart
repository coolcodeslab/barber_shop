import 'package:barber_shop/auth_service.dart';
import 'package:barber_shop/constants.dart';
import 'package:flutter/material.dart';
import 'package:barber_shop/barber_widgets.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const id = 'reset password screen';
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  String email;
  bool error = false;

  TextEditingController emailController = TextEditingController();
  Authentication authentication = Authentication();
  void onTapResetPassword() {
    if (emailController.text.isEmpty) {
      setState(() {
        error = true;
      });
    } else {
      authentication.resetPassword(email: email);
    }

    print(email);
  }

  void onChangeEmail(n) {
    email = n;
    setState(() {
      error = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
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
              height: height * 0.06,
            ),

            //Email field
            TextFieldWidget(
              hintText: 'Registered Email',
              onChanged: onChangeEmail,
              controller: emailController,
              errorText: error ? 'Email cannot be null' : null,
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                'An email will be sent to reset your password',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),

            //Forgot password Button
            RoundButtonWidget(
              title: 'reset password',
              onTap: onTapResetPassword,
            ),
          ],
        ),
      ),
    );
  }
}

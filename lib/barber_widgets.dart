import 'package:barber_shop/constants.dart';
import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/screens/add_booking_screen.dart';
import 'package:barber_shop/screens/address_book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

/*round button used in all parts of the app with dynamic title,
* height and width */
class RoundButtonWidget extends StatelessWidget {
  RoundButtonWidget(
      {this.title, this.onTap, this.height = 40, this.width = 254});

  final String title;
  final Function onTap;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            )
          ],
          color: kButtonColor,
          borderRadius: BorderRadius.circular(30),
        ),
        margin: EdgeInsets.only(
          bottom: 20,
        ),
        height: height,
        width: width,
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

//text field widget used in all parts of the app
class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    this.hintText,
    this.onChanged,
    this.obscureText = false,
    this.errorText,
    this.controller,
    this.maxLines,
    this.maxLength,
  });

  final String hintText;
  final Function onChanged;
  final bool obscureText;
  final String errorText;
  final TextEditingController controller;
  final int maxLines;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.only(left: 20, right: 20),
      margin: EdgeInsets.only(
        bottom: 20,
        left: 30,
        right: 30,
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        onChanged: onChanged,
        obscureText: obscureText,
        maxLines: maxLines,
        maxLength: maxLength,
        decoration: InputDecoration(
          errorText: errorText,
          hintText: hintText,
          hintStyle: kTextFieldHintStyle,
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }
}

class BoxContainer extends StatelessWidget {
  BoxContainer(
      {this.margin, this.onTap, this.child, this.imageUrl, this.title});

  final EdgeInsetsGeometry margin;
  final Function onTap;
  final Widget child;
  final String imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: height * 0.15,
        width: width * 0.38,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: Text(
                title,
                style: kBoxContainerTextStyle,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: height * 0.18,
                width: width * 0.48,
                decoration: BoxDecoration(
                  image: imageUrl == null
                      ? null
                      : DecorationImage(
                          image: AssetImage(
                            imageUrl,
                          ),
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            ),
          ],
          color: kBoxContainerColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}

class ServiceContainer extends StatelessWidget {
  ServiceContainer({this.onTap, this.child, this.name, this.imageUrl});

  final Function onTap;
  final Widget child;
  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Container(
              height: height * 0.12,
              width: width * 0.107,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
            SizedBox(
              height: height * 0.015,
            ),
            Text(
              name,
              style: kServiceContainerTextStyle,
            )
          ],
        ),
        margin: EdgeInsets.only(right: 10, left: 10),
        width: width * 0.347,
        decoration: BoxDecoration(
          color: kBoxContainerColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  DrawerButton({this.onTap});

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Icon(
          Icons.menu,
          color: kButtonColor,
        ),
      ),
    );
  }
}

class HorizontalRows extends StatelessWidget {
  HorizontalRows({this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: height * 0.217, //<- Here the height should be specific
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: children,
      ),
    );
  }
}

class PopUpContainer extends StatelessWidget {
  PopUpContainer({
    this.name,
    this.data,
    this.price,
    this.fromGetStarted,
    this.serviceName,
    this.imageUrl,
  });

  final String name;
  final String data;
  final String price;
  final bool fromGetStarted;
  final String serviceName;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
//            0xff4D4A56
        ),
        width: width * 0.693,
        height: height * 0.55,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: height * 0.255,
                width: width * 0.4,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                name,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '\$$price',
                style: TextStyle(
                  fontSize: 26,
                  color: kButtonColor,
                ),
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            RoundButtonWidget(
              onTap: () async {
                /*If it is fromGetStarted == true then book now button is shown
                If fromGetStarted != true buy now button is shown*/

                Navigator.pop(context); // Closing Dialog
                fromGetStarted
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddBookingScreen(serviceName: serviceName)))
                    : Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddressBook()));

                // Going to Address Book
              },
              title: fromGetStarted ? 'Book now' : 'Buy now',
              width: width * 0.339,
            )
          ],
        ),
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  ItemContainer({this.onTap, this.name, this.imageUrl});

  final Function onTap;
  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(left: 5, right: 5, top: 10),
        margin: EdgeInsets.only(bottom: 10, left: 10),
        decoration: BoxDecoration(
          color: kItemContainerColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Container(
              height: height * 0.12,
              width: width * 0.213,
              child: CachedNetworkImage(
                imageUrl: imageUrl,
              ),
            ),
            SizedBox(
              height: height * 0.015,
            ),
            Text(
              name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PopUpServiceContainer extends StatelessWidget {
  PopUpServiceContainer(
      {this.title,
      this.description,
      this.price,
      this.imageUrl,
      this.onTapBookNow});

  final String title;
  final String description;
  final String price;
  final String imageUrl;
  final Function onTapBookNow;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: kPopUpServiceContainerTitleStyle,
                    ),
                    Text(
                      '\$$price',
                      style: kPopUpServiceContainerPriceStyle,
                    ),
                  ],
                ),
                Container(
                  height: height * 0.12,
                  width: width * 0.107,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.015,
            ),
            Container(
              height: height * 0.285,
              child: Text(
                description,
                style: kPopUpServiceContainerDescriptionStyle.copyWith(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RoundButtonWidget(
                  title: 'book now',
                  onTap: onTapBookNow,
                  width: width * 0.32,
                  height: height * 0.06,
                ),
              ],
            ),
          ],
        ),
        height: height * 0.555,
        width: width * 0.853,
        decoration: BoxDecoration(
          color: Colors.white,
//            0xff7F7B78
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(25),
            topLeft: Radius.circular(25),
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
    );
  }
}

class TimeContainer extends StatelessWidget {
  TimeContainer({this.time, this.onTap, this.color, this.isBooked = false});

  final String time;
  final Function onTap;
  final Color color;
  final bool isBooked;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            time,
            style: TextStyle(color: isBooked ? Colors.red : Colors.black),
          ),
        ),
        width: width * 0.027,
        margin: EdgeInsets.all(10),
      ),
    );
  }
}

class SocialSignInButton extends StatelessWidget {
  SocialSignInButton({this.onPressed, this.buttons, this.color});

  final Function onPressed;
  final Buttons buttons;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.06,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 5),
            )
          ]),
      child: SignInButton(
        buttons,
        onPressed: onPressed,
        elevation: 0,
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..color = color
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius);
    canvas.drawCircle(circleOffset, radius, _paint);
  }
}

class BackGroundDesign extends StatelessWidget {
  BackGroundDesign({this.width, this.height});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.transparent,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: AssetImage('images/roundDesign3.png'),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  const BookingCard({
    @required this.name,
    this.service,
    this.time,
    this.day,
    this.bookingId,
    this.onTapCancel,
  });

  final String time;
  final String service;
  final String day;
  final String name;
  final String bookingId;
  final Function onTapCancel;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      height: height * 0.3,
      width: width * 0.773,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ///user name and time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$name',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    '#$bookingId',
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              Text(
                '$time \n$day',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),
            ],
          ),

          Divider(),

          ///service name
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              '$service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          Divider(),

          ///cancel button
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                onTap: onTapCancel,
                child: Container(
                  height: height * 0.045,
                  width: width * 0.27,
                  decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(5)),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SmallActionButton extends StatelessWidget {
  SmallActionButton({this.title, this.onTap});

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(title),
        ),
        margin: EdgeInsets.symmetric(
          vertical: 10,
        ),
        height: 30,
        width: 70,
        decoration: BoxDecoration(
          color: kItemContainerColor,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({
    this.onTap,
  });

  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: 20,
        ),
        child: Text(
          'forgot password?',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class DropDownWidget extends StatelessWidget {
  DropDownWidget({
    @required this.serviceList,
    this.onChanged,
    this.serviceName,
  });

  final List<String> serviceList;
  final Function onChanged;
  final String serviceName;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.only(
          bottom: 20,
          left: 30,
          right: 30,
        ),
        child: DropdownButton<String>(
          underline: Container(),
          elevation: 0,
          iconSize: 40,
          isExpanded: true,
          value: serviceName,
          items: serviceList.map(
            (String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(color: Colors.white),
                ),
              );
            },
          ).toList(),
          dropdownColor: Colors.black.withOpacity(0.9),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

class ItemScreenTopMessage extends StatelessWidget {
  const ItemScreenTopMessage({
    Key key,
  });

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: height * 0.15,
      width: width * 0.8,
      child: Row(
        children: [
          Container(
            width: 2,
            height: height * 0.105,
            color: Colors.black.withOpacity(0.5),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What happens in the',
                  style: GoogleFonts.karla(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Text(
                  'Barber shop',
                  style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Stays in the',
                  style: GoogleFonts.karla(
                    fontSize: 12,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
                Text(
                  'Barber shop',
                  style: GoogleFonts.dancingScript(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: width * 0.107,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: width * 0.187,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/personwithabeard.png'),
                ),
              ),
            ),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: kItemContainerColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
      ),
    );
  }
}

class PickATimeButton extends StatelessWidget {
  PickATimeButton({this.onTap, this.isTimePicked, this.title});
  final Function onTap;
  final bool isTimePicked;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.only(left: 20, right: 20, top: 15),
        margin: EdgeInsets.only(
          bottom: 20,
          left: 30,
          right: 30,
        ),
        height: height * 0.067,
        width: width,
        child: Text(
          title,
          style: TextStyle(
            color: isTimePicked ? Colors.white : Colors.red,
          ),
        ),
      ),
    );
  }
}

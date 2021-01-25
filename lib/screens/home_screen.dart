import 'package:barber_shop/constants.dart';
import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/screens/add_booking_screen.dart';
import 'package:barber_shop/screens/item_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/screens/drawer_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'home screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: kBackgroundColor,
        endDrawer: CustomDrawer(
          width: width,
        ),

        //FAB is displayed only in the user app
        floatingActionButton: RoundButtonWidget(
          onTap: onTapBookNow,
          title: 'Book Now',
          width: width * 0.32,
        ),

        body: Stack(
          children: [
//            BackGround Design
            BackGroundDesign(
              height: height * 0.75,
              width: width * 1.333,
            ),

            //Main body
            ListView(
              children: [
                SizedBox(
                  height: height * 0.03,
                ),

                //Drawer icon
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DrawerButton(
                        //opens Drawer
                        onTap: () => _scaffoldKey.currentState.openEndDrawer(),
                      ),
                    ],
                  ),
                ),

                //Hey text
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Hey',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                ),

//                UserName
                FutureBuilder(
                    future: _fireStore
                        .collection('users')
                        .doc(_auth.currentUser.uid)
                        .get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      final data = snapshot.data;
                      final name = data['userName'];

                      return Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(
                          name == null ? 'How can we help you' : name,
                          style: kHeadingTextStyle,
                        ),
                      );
                    }),

                //Divider
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    height: 0,
                    width: width * 0.667,
                    padding: EdgeInsets.only(left: 10),
                    child: Divider(
                      color: Colors.white.withOpacity(0.5),
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: 5,
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.015,
                ),

                //Horizontal Rows which displays Get started and Product containers
                HorizontalRows(
                  children: [
                    SizedBox(
                      width: width * 0.027,
                    ),

                    //Get started box
                    BoxContainer(
                      margin: EdgeInsets.only(right: 20),
                      title: 'Get Started',
                      imageUrl: 'images/getStartedImage.png',
                      onTap: onTapGetStarted,
                    ),

                    //Products box
                    BoxContainer(
                      imageUrl: 'images/products.png',
                      title: 'Products',
                      onTap: onTapProducts,
                    ),
                  ],
                ),

                //Services heading
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Text(
                    'Services',
                    style: kServicesTextStyle,
                  ),
                ),

                /*Row 1

                Horizontal Rows which displays the service Containers from
                  FireBase service collection*/
                StreamBuilder(
                  stream: _fireStore
                      .collection('services')
                      .where('up', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    final dataLength = snapshot.data.docs.length;
                    final serviceList = snapshot.data.docs;

                    return HorizontalRows(
                      children: List.generate(
                        dataLength,

                        //Service Container
                        (index) => ServiceContainer(
                          imageUrl: serviceList[index]['imageUrl'],
                          onTap: () {
                            onTapServiceContainer(
                              name: serviceList[index]['name'],
                              description: serviceList[index]['description'],
                              price: serviceList[index]['price'],
                              imageUrl: serviceList[index]['imageUrl'],
                            );
                          },
                          name: serviceList[index]['name'],
                        ),
                      ),
                    );
                  },
                ),

                //Row 2
                /*Horizontal Rows which displays the service Containers from
                  FireBase service collection*/
                StreamBuilder(
                    stream: _fireStore
                        .collection('services')
                        .where('up', isNotEqualTo: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      final dataLength = snapshot.data.docs.length;
                      final serviceList = snapshot.data.docs;

                      return HorizontalRows(
                        children: List.generate(
                          dataLength,

                          //Service Container
                          (index) => ServiceContainer(
                            /*On tap passes the relevant data to the container when
                                Tapped

                                Data is determined by the the index of the current item
                                in the list which chooses from the firebase services
                                collection list */
                            imageUrl: serviceList[index]['imageUrl'],
                            onTap: () {
                              onTapServiceContainer(
                                name: serviceList[index]['name'],
                                description: serviceList[index]['description'],
                                price: serviceList[index]['price'],
                                imageUrl: serviceList[index]['imageUrl'],
                              );
                            },
                            name: serviceList[index]['name'],
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /*When Book now button is pressed it pushes to th booking screen*/
  void onTapBookNow() {
    setState(() {
      Provider.of<ProviderData>(context, listen: false).isTimePicked = false;
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddBookingScreen(
            serviceName: kDropDownFirstValue,
          ),
        ));
  }

  /*Passes the relevant sections that should be displayed in the tab bar
  and the heading

  These heading and sections are passes again to itemList widget where the
  data is retrieved from FireStore

  Be careful with the values being passed because if you changed the value then
  the value should be changed in FireStore ass well!*/

  void onTapGetStarted() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemScreen(
          title: 'get started',
          section1: 'all',
          section2: 'haircut',
          section3: 'beard',
          section4: 'trimming',
          fromGetStarted: true,
        ),
      ),
    );
  }

  /*Passes the relevant sections that should be displayed in the tab bar
  and the heading

  From getStarted bool is also passed */
  void onTapProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemScreen(
          title: 'products',
          section1: 'Accessories',
          section2: 'Essentials',
          section3: 'Men',
          section4: 'Women',
          fromGetStarted: false,
        ),
      ),
    );
  }

  /*When service container is tapped a dialog box pops up with the name
  description and price passed

  This zooms in the relevant service and gives the user a better view */
  void onTapServiceContainer(
      {String name, String description, String price, String imageUrl}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          //PopUpServiceContainer
          child: PopUpServiceContainer(
            title: name,
            description: description,
            price: price,
            imageUrl: imageUrl,
            onTapBookNow: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          AddBookingScreen(serviceName: name)));
            },
          ),
        );
      },
    );
  }
}

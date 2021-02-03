import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/provider_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/*
The user is allowed to view products in different sections

Click products

Buy function will be added with a modalBottom Sheet popping up
when pressed buy now button

 */
class ItemScreen extends StatefulWidget {
  static const id = 'item screen';
  ItemScreen({
    this.title,
    this.section1,
    this.section2,
    this.section3,
    this.section4,
    this.fromGetStarted,
  });
  final String title;
  final String section1;
  final String section2;
  final String section3;
  final String section4;
  final bool fromGetStarted;

  @override
  _ItemScreenState createState() => _ItemScreenState();
}

class _ItemScreenState extends State<ItemScreen>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 4,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Stack(
        children: [
          ///Background Design
          BackGroundDesign(
            height: height * 0.45,
            width: width * 0.8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.045,
              ),

              ///Back button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    BackButton(
                      color: kButtonColor,
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ],
                ),
              ),

              //what happens in the..
              ItemScreenTopMessage(),

              ///'Your choice' heading
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                  top: 10,
                ),
                child: Text(
                  'Your Choice',
                  style: kHeadingTextStyle,
                ),
              ),

              ///Tab bars
              Padding(
                padding: EdgeInsets.all(10),
                child: TabBar(
                  indicator: CircleTabIndicator(color: Colors.black, radius: 4),
                  controller: tabController,
                  isScrollable: false,
                  indicatorColor: Colors.white,
                  labelColor: Colors.black,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.black.withOpacity(0.5),
                  labelStyle: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: <Widget>[
                    Tab(
                      child: Text(widget.section1),
                    ),
                    Tab(
                      child: Text(widget.section2),
                    ),
                    Tab(
                      child: Text(widget.section3),
                    ),
                    Tab(
                      child: Text(widget.section4),
                    ),
                  ],
                ),
              ),

              //Pages for each tab
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    /*Read the line before itemList State to have better understanding
                    about what is being passed and why */
                    ItemList(
                      collection: widget.title,
                      doc: widget.section1,
                      fromGetStarted: widget.fromGetStarted,
                    ),

                    /*Read the line before itemList State to have better understanding
                    about what is being passed and why*/
                    ItemList(
                      collection: widget.title,
                      doc: widget.section2,
                      fromGetStarted: widget.fromGetStarted,
                    ),

                    /*Read the line before itemList State to have better understanding
                    about what is being passed and why*/
                    ItemList(
                      collection: widget.title,
                      doc: widget.section3,
                      fromGetStarted: widget.fromGetStarted,
                    ),

                    /*Read the line before itemList State to have better understanding
                    about what is being passed and why*/
                    ItemList(
                      collection: widget.title,
                      doc: widget.section4,
                      fromGetStarted: widget.fromGetStarted,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/*Each section is a separate stateful widget

Category(collection), sections(documentID), collections(sub collection) is
passed when user navigates to different section*/
class ItemList extends StatefulWidget {
  ItemList({
    this.doc,
    this.collection,
    this.fromGetStarted,
  });
  final String collection;
  final String doc;
  final bool fromGetStarted;

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final _fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      color: kBackgroundColor,
      child: StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection(widget.collection)
            .doc(widget.doc)
            .collection(kItemScreenSubCollectionName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Theme(
                data: ThemeData(accentColor: kButtonColor),
                child: CircularProgressIndicator(),
              ),
            );
          }
          final dataLength = snapshot.data.docs.length;
          final products = snapshot.data.docs;
          return GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 80 / 100,
            children: List.generate(
              dataLength,
              (index) {
                //Item Container
                return ItemContainer(
                  name: products[index]['product name'],
                  imageUrl: products[index]['imageUrl'],
                  onTap: () {
                    /*When item is tapped the relevant price, product id and
                    product name is set to provider variables which will be
                    used in order summary screen*/

                    setState(() {
                      Provider.of<ProviderData>(context, listen: false).price =
                          products[index]['price'];
                      Provider.of<ProviderData>(context, listen: false)
                          .productId = products[index]['product id'];
                      Provider.of<ProviderData>(context, listen: false)
                          .productName = products[index]['product name'];
                    });

                    //OnTapItemContainer
                    onTapItemContainer(
                      name: products[index]['product name'],
                      price: products[index]['price'],
                      serviceName: widget.doc,
                      imageUrl: products[index]['imageUrl'],
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }

  /*When container is tapped a popUpContainer is popped up with the
  name of the product and price*/
  void onTapItemContainer(
      {String name, String price, String serviceName, String imageUrl}) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation1, animation2) {
        return Center(
          child: PopUpContainer(
            name: name,
            price: price,
            fromGetStarted: widget.fromGetStarted,
            serviceName: serviceName,
            imageUrl: imageUrl,
          ),
        );
      },
    );
  }
}

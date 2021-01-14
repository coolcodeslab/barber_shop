import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
The user is allowed to view products in different sections

Click products

Buy function will be added with a modalBottom Sheet popping up
when pressed buy now button

 */
class ItemScreen extends StatefulWidget {
  static const id = 'item screen';
  ItemScreen(
      {this.title,
      this.section1,
      this.section2,
      this.section3,
      this.section4,
      this.fromGetStarted});
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
    // TODO: implement initState
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
          //Background Design
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
              ItemScreenTopMessage(),
              //Heading
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

              //Tab bars
              Padding(
                padding: EdgeInsets.all(10),
                child: TabBar(
                  indicator: CircleTabIndicator(color: Colors.white, radius: 4),
                  controller: tabController,
                  isScrollable: false,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 12,
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
                      category: widget.title,
                      section: widget.section1,
                    ),

                    /*Read the line before itemList State to have better understanding
                    about what is being passed and why*/
                    ItemList(
                      category: widget.title,
                      section: widget.section2,
                    ),

                    /*Read the line before itemList State to have better understanding
                    about what is being passed and why*/
                    ItemList(
                      category: widget.title,
                      section: widget.section3,
                    ),

                    /*Read the line before itemList State to have better understanding
                    about what is being passed and why*/
                    ItemList(
                      category: widget.title,
                      section: widget.section4,
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
    this.section,
    this.category,
  });
  final String category;
  final String section;

  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  final _fireStore = FirebaseFirestore.instance;

  /*When container is tapped a popUpContainer is popped up with the
  name of the product*/
  void onTapItemContainer(String name) {
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.only(right: 10),
      color: kBackgroundColor,
      child: StreamBuilder<QuerySnapshot>(
        stream: _fireStore
            .collection(widget.category)
            .doc(widget.section)
            .collection(kItemScreenSubCollectionName)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
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
                  onTap: () {
                    onTapItemContainer(
                      products[index]['product name'],
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
}

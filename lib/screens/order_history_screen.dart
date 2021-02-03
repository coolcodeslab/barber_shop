import 'package:barber_shop/models/order_history_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber_shop/constants.dart';
import 'package:intl/intl.dart';

class OrderHistoryScreen extends StatefulWidget {
  static const id = 'order history screen';
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final _auth = FirebaseAuth.instance;
  String uid;
  final scrollController = ScrollController();
  OrdersHistoryModel orders;

  @override
  void initState() {
    uid = _auth.currentUser.uid;

    orders = OrdersHistoryModel(uid: uid);

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        orders.loadMore();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kButtonColor,
        ),
        title: Text(
          'Orders',
          style: kHeadingTextStyle,
        ),
        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: kBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: StreamBuilder(
          stream: orders.stream,
          builder: (BuildContext _context, AsyncSnapshot _snapshot) {
            if (!_snapshot.hasData) {
              return Center(
                child: Theme(
                  data: ThemeData(
                    accentColor: kButtonColor,
                  ),
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return RefreshIndicator(
                color: kButtonColor,
                onRefresh: orders.refresh,
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  controller: scrollController,
                  separatorBuilder: (context, index) => Container(),
                  itemCount: _snapshot.data.length + 1,
                  itemBuilder: (BuildContext _context, int index) {
                    if (index < _snapshot.data.length) {
                      return OrderContainer(order: _snapshot.data[index]);
                    } else if (orders.hasMore) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(
                          child: Theme(
                            data: ThemeData(
                              accentColor: kButtonColor,
                            ),
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: Center(child: Text('nothing more to load!')),
                      );
                    }
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  OrderContainer({this.order});

  final OrderHistoryModel order;

  @override
  Widget build(BuildContext context) {
    var date = order.timeStamp.toDate();
    final passedDate = DateTime(date.year, date.month, date.day);
    final purchasedDate = DateFormat('yMMMEd').format(passedDate);

    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ///Order with Icon
              Row(
                children: [
                  Icon(
                    Icons.bookmark_border,
                    color: kButtonColor,
                  ),
                  Text(
                    'Order',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),

              ///Date
              Text(
                purchasedDate,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Divider(),

          ///Product name and price
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(
              order.productName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 7,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                '\$${order.productPrice}',
              ),
            ),
          ),
          Divider(),

          ///Address
          Row(
            children: [
              Icon(
                Icons.pin_drop,
                color: kButtonColor,
                size: 16,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                order.shippingAddress,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),

          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Status',
                style: TextStyle(color: Colors.blue),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 7),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  'Paid',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

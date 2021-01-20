import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barber_shop/constants.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  String uid;

  @override
  void initState() {
    uid = _auth.currentUser.uid;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.015,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                BackButton(
                  color: kButtonColor,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 20,
            ),
            child: Text(
              'Orders',
              style: kHeadingTextStyle,
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          /*All the order in the currents users booking collections
              is displayed

              Only name of the name given when booking is displayed*/
          StreamBuilder<QuerySnapshot>(
            stream: _fireStore
                .collection('users')
                .doc(uid)
                .collection('orders')
                .orderBy('timeStamp')
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
              List<Widget> orderList = [];
              final orders = snapshot.data.docs;
              for (var order in orders) {
                final shippingAddress = order['ShippingAddress'];
                final transactionId = order['StripTransactionId'];
                final productId = order['productId'];
                final productPrice = order['productPrice'];
                final productName = order['productName'];

                final orderContainer = OrderContainer(
                  shippingAddress: shippingAddress,
                  transactionId: transactionId,
                  productId: productId,
                  productPrice: productPrice,
                  productName: productName,
                );
                //Add container to list
                orderList.add(orderContainer);
              }

              return Column(
                children: orderList,
              );
            },
          )
        ],
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  OrderContainer({
    @required this.shippingAddress,
    @required this.transactionId,
    @required this.productId,
    @required this.productPrice,
    @required this.productName,
  });

  final String shippingAddress;
  final String transactionId;
  final String productId;
  final String productPrice;
  final String productName;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 30),
      height: height * 0.2,
      width: width * 0.773,
      decoration: BoxDecoration(
        color: Color(0xff7F7B78),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            productName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          Text(
            '\$$productPrice',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            shippingAddress,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

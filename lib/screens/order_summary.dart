import 'package:barber_shop/barber_widgets.dart';
import 'package:barber_shop/constants.dart';
import 'package:barber_shop/provider_data.dart';
import 'package:barber_shop/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class OrderSummary extends StatefulWidget {
  final Map payLoad;

  OrderSummary({Key key, this.payLoad}) : super(key: key);

  @override
  _OrderSummaryState createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  final _auth = FirebaseAuth.instance;
  String uid;
  DateTime timeStamp;

  @override
  void initState() {
    DateTime now = DateTime.now();
    timeStamp = DateTime(now.year, now.month, now.day);
    uid = _auth.currentUser.uid;
    StripePayment.setOptions(StripeOptions(
        publishableKey: StripApiKey,
        merchantId: "coolcodes01@gmail.com",
        androidPayMode: ''));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final price = Provider.of<ProviderData>(context).price;
    final productID = Provider.of<ProviderData>(context).productId;
    final productName = Provider.of<ProviderData>(context).productName;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ListView(
        children: [
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

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              "Address",
              style: kHeadingTextStyle,
            ),
          ),

          OrderSummaryTile(
            title: 'Product',
            subTitle: productName,
          ),

          Divider(),
          OrderSummaryTile(
            title: 'price',
            subTitle: '\$$price',
          ),
          Divider(),
          OrderSummaryTile(
            title: 'Address',
            subTitle: widget.payLoad['address'] ?? "N/a",
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: RoundButtonWidget(
              title: 'Pay & Place Order',
              onTap: () {
                print('tapped');
                StripePayment.paymentRequestWithNativePay(
                  androidPayOptions: AndroidPayPaymentRequest(
                    totalPrice: "$price", // TODO PASS AMT AND SET UP HERE
                    currencyCode: "USD",
                  ),
                  applePayOptions: ApplePayPaymentOptions(
                    countryCode: 'DE',
                    currencyCode: 'USD',
                    items: [
                      ApplePayItem(
                        label: '$productName',
                        amount: '$price', // TODO PASS AMT AND SET UP HERE
                      )
                    ],
                  ),
                ).then((token) {
                  print(token.tokenId);
                  StripePayment.completeNativePayRequest().then((_) {});
                  setupOrder(
                    token.tokenId,
                    token,
                    productId: productID,
                    productName: productName,
                    productPrice: price,
                  );
                });
                print('done');
              },
            ),
          ),
        ],
      ),
    );
  }

  void setupOrder(transactionId, Token token,
      {String productName, String productPrice, String productId}) {
    print('done');
    try {
      FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("orders")
          .doc(transactionId)
          .set({
        "productName": productName,
        "productPrice": productPrice,
        "productId": productId,
        "StripTransactionId": transactionId,
        "ShippingAddress": widget.payLoad['address'],
        "token": token.toJson(),
        'timeStamp': timeStamp,
      }).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
        Navigator.pop(context, true);
      });
      FirebaseFirestore.instance.collection('orders').doc(transactionId).set({
        'customerEmail': _auth.currentUser.email,
        "productName": productName,
        "productPrice": productPrice,
        "productId": productId,
        "StripTransactionId": transactionId,
        "ShippingAddress": widget.payLoad['address'],
        "token": token.toJson(),
        'timeStamp': timeStamp,
        'completed': false,
        'userName': _auth.currentUser.displayName,
      });
    } catch (err) {
      print("Error on Fetching Address ==> $err");
    }
  }
}

class OrderSummaryTile extends StatelessWidget {
  const OrderSummaryTile({
    this.subTitle,
    this.title,
  });

  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subTitle,
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}

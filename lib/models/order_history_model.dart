import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

final _fireStore = FirebaseFirestore.instance;

/// Example data as it might be returned by an external service
/// ...this is often a `Map` representing `JSON` or a `FireStore` document
Future<List<QueryDocumentSnapshot>> getOrderData(
    {int length, String uid}) async {
  QuerySnapshot data = await _fireStore
      .collection('users')
      .doc(uid)
      .collection('orders')
      .orderBy('timeStamp', descending: true)
      .get();

  return Future.delayed(Duration(seconds: 1), () {
    return List.generate(length, (int index) {
      return data.docs[index];
    });
  });
}

/// OrderModel has a constructor that can handle the `Map` data
/// ...from the server.
class OrderHistoryModel {
  var timeStamp;
  String productId;
  String stripTransactionId;
  String productName;
  String productPrice;
  String shippingAddress;

  OrderHistoryModel({
    this.timeStamp,
    this.productId,
    this.stripTransactionId,
    this.shippingAddress,
    this.productName,
    this.productPrice,
  });

  factory OrderHistoryModel.fromServerMap(QueryDocumentSnapshot data) {
    return OrderHistoryModel(
      productId: data['productId'],
      stripTransactionId: data['StripTransactionId'],
      timeStamp: data['timeStamp'],
      shippingAddress: data['ShippingAddress'],
      productName: data['productName'],
      productPrice: data['productPrice'],
    );
  }
}

/// OrdersModel controls a `Stream` of posts and handles
/// ...refreshing data and loading more posts
class OrdersHistoryModel {
  Stream<List<OrderHistoryModel>> stream;
  bool hasMore;

  bool _isLoading;
  List<QueryDocumentSnapshot> _data;
  StreamController<List<QueryDocumentSnapshot>> _controller;

  String uid;

  OrdersHistoryModel({this.uid}) {
    _data = List<QueryDocumentSnapshot>();
    _controller = StreamController<List<QueryDocumentSnapshot>>.broadcast();
    _isLoading = false;
    stream = _controller.stream.map((List<QueryDocumentSnapshot> postsData) {
      return postsData.map((QueryDocumentSnapshot postData) {
        return OrderHistoryModel.fromServerMap(postData);
      }).toList();
    });
    hasMore = true;
    refresh();
  }

  Future<void> refresh() {
    return loadMore(clearCachedData: true);
  }

  Future<void> loadMore({
    bool clearCachedData = false,
  }) async {
    final fireStoreLength = await _fireStore
        .collection('users')
        .doc(uid)
        .collection('orders')
        .get()
        .then((value) => value.docs.length);

    int getOrderDataLength;
    if (fireStoreLength < 3) {
      getOrderDataLength = fireStoreLength;
    } else {
      getOrderDataLength = 3;
    }

    if (clearCachedData) {
      _data = List<QueryDocumentSnapshot>();
      hasMore = true;
    }
    if (_isLoading || !hasMore) {
      return Future.value();
    }

    _isLoading = true;

    return getOrderData(length: getOrderDataLength, uid: uid)
        .then((postsData) async {
      _isLoading = false;
      _data.addAll(postsData);
      hasMore = (_data.length < fireStoreLength);
      _controller.add(_data);
    });
  }
}

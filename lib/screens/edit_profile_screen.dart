import 'dart:io';
import 'dart:math';

import 'package:barber_shop/barber_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:random_string/random_string.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({this.userName, this.mobileNumber, this.imageUrl});
  final String userName;
  final String mobileNumber;
  final String imageUrl;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fireStore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance.ref().child('images');

  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  final picker = ImagePicker();

  String uid;
  bool showSpinner = false;
  String imageUrl;
  File _image;
  bool error = false;

  @override
  void initState() {
    uid = _auth.currentUser.uid;
    nameController.text = widget.userName;
    mobileNumberController.text = widget.mobileNumber;
    imageUrl = widget.imageUrl;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: BackButton(),
              ),
              SizedBox(
                height: 20,
              ),
              TextFieldWidget(
                hintText: 'user name',
                errorText: error ? 'please enter a value' : null,
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: nameController.text ?? "",
                    selection: TextSelection.collapsed(
                        offset: nameController.text?.length ?? 0),
                  ),
                ),
                onChanged: (n) {
                  nameController.text = n;
                },
              ),
              TextFieldWidget(
                hintText: 'mobile number',
                errorText: error ? 'please enter a value' : null,
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: mobileNumberController.text ?? "",
                    selection: TextSelection.collapsed(
                        offset: mobileNumberController.text?.length ?? 0),
                  ),
                ),
                onChanged: (n) {
                  mobileNumberController.text = n;
                },
              ),
              SmallActionButton(
                title: 'image',
                onTap: onTapImage,
              ),
              SizedBox(
                height: 300,
              ),
              RoundButtonWidget(
                title: 'Save changes',
                onTap: () {
                  onTapSaveChanges(_image);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void onTapImage() async {
    print('picking image');
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      },
    );
    print('done');
  }

  void onTapSaveChanges(File file) async {
    print(nameController.text);
    print(mobileNumberController.text);
    print(imageUrl);

    print('uploading');

    setState(() {
      showSpinner = true;
    });

    if (nameController.text.isEmpty || mobileNumberController.text.isEmpty) {
      setState(() {
        showSpinner = false;
        error = true;
      });
    } else {
      final String r = randomAlphaNumeric(9);

      try {
        await _firebaseStorage.child('$r.jpg').putFile(file).then(
          (data) async {
            await data.ref.getDownloadURL().then((value) => imageUrl = value);
          },
        );
      } catch (e) {
        print(e);
      }

      print('got download url');

      saveToFireStore();

      print('done');

      setState(() {
        showSpinner = false;
      });

      Navigator.pop(context);
    }
  }

  void saveToFireStore() {
    try {
      _fireStore.collection('users').doc(uid).update({
        'name': nameController.text,
        'mobileNumber': mobileNumberController.text,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print(e);
    }
  }
}

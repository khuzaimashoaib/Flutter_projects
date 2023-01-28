import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:finstagram/services/firebase_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  double? deviceHeight, deviceWidth;
  FirebaseService? firebaseService;
  final GlobalKey<FormState> signupKey = GlobalKey<FormState>();
  String? name, email, password;
  File? image;
  

  @override
  void initState() {
    super.initState();
    firebaseService = GetIt.instance.get<FirebaseService>();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: deviceWidth! * 0.05),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                titleWidget(),
                profilePicWidget(),
                signupForm(),
                signupBtn(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget() {
    return const Text(
      "Finstagram",
      style: TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget profilePicWidget() {
    var imageProvider = image != null
        ? FileImage(image!)
        : const NetworkImage("https://i.pravatar.cc/300");
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((results) {
          setState(() {
            image = File(results!.files.first.path!);
          });
        });
      },
      child: Container(
        height: deviceHeight! * 0.15,
        width: deviceHeight! * 0.15,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget signupForm() {
    return Container(
      height: deviceHeight! * 0.30,
      child: Form(
        key: signupKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userNameTxtField(),
            emailTxtField(),
            passTxtField(),
          ],
        ),
      ),
    );
  }

  Widget userNameTxtField() {
    return TextFormField(
        decoration: const InputDecoration(hintText: "UserName..."),
        validator: (value) => value!.length > 0 ? null : "Please enter a name",
        onSaved: (value) {
          setState(() {
            name = value;
          });
        });
  }

  Widget emailTxtField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "Email..."),
      onSaved: (value) {
        setState(() {
          email = value;
        });
      },
      validator: (value) {
        bool result = value!.contains(RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"));
        return result ? null : "Please enter valid Email";
      },
    );
  }

  Widget passTxtField() {
    return TextFormField(
        obscureText: true,
        decoration: const InputDecoration(hintText: "Password..."),
        onSaved: (value) {
          setState(() {
            password = value;
          });
        },
        validator: (value) =>
            value!.length > 6 ? null : "Enter min 6 charcter");
  }

  Widget signupBtn() {
    return MaterialButton(
      onPressed: signupUser,
      minWidth: deviceWidth! * 0.50,
      height: deviceHeight! * 0.05,
      color: Colors.red,
      child: const Text(
        "Sign up",
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  void signupUser() async {
    if (signupKey.currentState!.validate() && image != null) {
      signupKey.currentState!.save();
      bool result = await firebaseService!.signUpUser(
        name: name!,
        email: email!,
        password: password!,
        image: image!,
      ); 
      if (result) Navigator.pop(context);
      
    }
  }
}
